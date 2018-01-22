require 'infoboxer'

module Reality
  using Refinements

  module DataSources
    class Wikivoyage
      def get(title)
        internal.get(title).derp(&method(:parse))
      end

      private

      def internal
        @internal ||= Infoboxer.wikivoyage
      end

      def parse(page)
        simple_templates(page) #+
          #%w[see do buy eat drink sleep].flat_map do |activity|
            #page.templates(name: activity).map(&method(:parse_venue)).map { |v| [activity, v] }
          #end +
          #page.templates(name: 'listing').map(&method(:parse_venue)).map { |v| ['listing', v] }
      end

      def parse_venue(template)
        template.variables
          .map { |var| [var.name.to_sym, var.children.text] }
          .reject { |n, v| v.empty? }.to_h
          .tap { |hash|
            if hash.key?(:lat) && hash.key?(:long)
              hash[:coord] = Geo::Coord.new(hash.delete(:lat).to_f, hash.delete(:long).to_f)
            end
          }.merge(section: template.in_sections.first.heading.text_)
      end

      QUALITIES = /^(usable|guide|star|outline)/i

      def simple_templates(page)
        [
          on_template(page, :coord, name: 'geo') { |t| Geo::Coord.new(*t.unnamed_variables.map(&:children).map(&:text).map(&:to_f)) },
          on_template(page, :iata, name: 'IATA') { |t| t .unnamed_variables.first.children.text },
          on_template(page, :is_part_of, name: 'IsPartOf') { |t| '#<Link[' + t.unnamed_variables.first.children.text + ']>' },
          on_template(page, :quality, name: QUALITIES) { |t| t.name.scan(QUALITIES).flatten.first },
          *on_template(page, :climate, name: 'climate', merge: true, &method(:parse_climate)),
          on_template(page, :route, name: 'routebox', &method(:parse_routes)),
          on_template(page, :region, name: 'regionlist', &method(:parse_regions)),
          on_template(page, :currency, name: 'exchange rates', &method(:parse_currency))
        ].compact
      end

      def on_template(page, symbol, *selectors, &block)
        merge = selectors.last.is_a?(Hash) ? selectors.last.delete(:merge) : false
        tpl = page.templates(*selectors).first or return nil
        if merge
          block.call(tpl)
        else
          [symbol, block.call(tpl)]
        end
      end

      MONTHES = Date::ABBR_MONTHNAMES.compact.map(&:downcase).freeze

      def parse_climate(template)
        MONTHES.map { |m|
          ["climate.#{m}",
            {
              temperature: Measure.new(template.fetch("#{m}low").text.to_f, '°C')..Measure.new(template.fetch("#{m}high").text.to_f, '°C'),
              precipation: Measure.new(template.fetch("#{m}precip").text.to_f, 'mm'),
            }
          ]
        }
      end

      ROSE = {
        N: 'north',
        S: 'south',
        E: 'east',
        W: 'west'
      }

      def parse_routes(template)
        max = template.variables.map(&:name).grep(/\d+$/).map { |n| n[/\d+$/].to_i }.max
        (1..max).map { |n|
          %w[left right].map { |dir|
            l = dir.chars.first
            direction = template.fetch("direction#{l}#{n}").text.chars.map { |c|
              ROSE[c.to_sym] or fail("Can't guess: #{c}")
            }.join('_')
            {
              "#{direction}.major": template.fetch("major#{l}#{n}").text,
              "#{direction}.minor": template.fetch("minor#{l}#{n}").text,
            }.reject { |_, v| v.empty? }
          }.inject(&:merge).merge(name: template.fetch("image#{n}").text.sub(/( icon)?\..+$/, ''))
        }
      end

      def parse_regions(template)
        # TODO: too naive! see Paris
        max = template.variables.map(&:name).grep(/region\d+/).map { |n| n[/\d+/].to_i }.max
        (1..max).map { |n| "#<Link[#{template.fetch("region#{n}name").text}]>" }
      end

      def parse_currency(template)
        # TODO: fetch date, make observations timed
        # TODO: more complicated for Australia. It fetches in fact Template:Exchangerate/AUD-EUR and similar
        {
          name: template.fetch('currency').text,
          symbol: template.fetch('currencyCode').text,
        }.merge(%w[USD EUR GBP].map { |to| {"exchange.#{to.downcase}": template.fetch(to).text.to_f} }.inject(:merge))
      end
    end
  end
end
