module Reality
  class Country
    def initialize(page)
      @page = page
    end

    def name
      page.title
    end

    def long_name
      infobox.fetch('conventional_long_name').text
    end

    def capital
      infobox.fetch('capital').lookup(:Wikilink).first
    end

    def languages
      infobox.fetch('official_languages').lookup(:Wikilink)
    end

    def tld
      tlds.first
    end

    def tlds
      infobox_links('cctld').map(&:link)
    end

    def calling_code
      infobox.fetch('calling_code').text
    end

    def utc_offset
      infobox.fetch('utc_offset').text.sub('−', '-').to_i
    end

    def currency
      currencies.first
    end

    def currencies
      infobox_links('currency').reject{|l| l.link == 'ISO 4217'}
    end

    def area
      Reality::Measure(infobox.fetch('area_km2').text.gsub(',', '').to_i, 'km²')
    end

    def population
      val = %w[population_estimate population_census].map{|var|
        infobox.fetch(var).text.strip
      }.reject(&:empty?).first
      Reality::Measure(val.gsub(',', '').to_i, 'person')
    end

    def leaders
      titles = infobox.fetch(/^leader_title\d/).map(&:text_)
      names = infobox.fetch(/^leader_name\d/).map{|v| v.lookup(:Wikilink).first}
      titles.zip(names).to_h
    end

    def continent
      self.class.by_continents[page.title]
    end

    def to_s
      name
    end

    def inspect
      "#<#{self.class}(#{name})>"
    end

    PROPERTIES = %i[
                    continent name long_name
                    tld tlds calling_code utc_offset
                    capital languages currency
                    leaders area population
                  ]

    def to_h
      PROPERTIES.
        map{|prop| [prop, to_simple_type(send(prop))]  }.
        #reject{|prop, val| !val || val.respond_to?(:empty?) && val.empty?}.
        to_h
    end

    class << self
      def by_continents
        @by_continents ||= Reality.wp.
          get('List of countries by continent').
          sections.first.
          sections.map{|s|
            continent = s.heading.text_
            s.tables.first.
              lookup(:Wikilink, :bold?).map(&:link).
              map{|country| [country, continent]}
          }.flatten(1).
          to_h
      end
    end

    private

    attr_reader :page

    def infobox
      page.infobox
    end

    def infobox_links(varname)
      src = infobox.fetch(varname)
      if tmpl = src.lookup(:Template, name: /list$/).first
        # values could be both inside and outside list, see India's cctld value
        src = Infoboxer::Tree::Nodes[src, tmpl.variables] 
      end
      src.lookup(:Wikilink)
    end

    def to_simple_type(val)
      case val
      when nil, Numeric, String, Symbol
        val
      when Array
        val.map{|v| to_simple_type(v)}
      when Hash
        val.map{|k, v| [to_simple_type(k), to_simple_type(v)]}.to_h
      when Infoboxer::Tree::Wikilink
        val.link
      when Infoboxer::Tree::Node
        val.text_
      when Reality::Measure
        val.amount
      else
        fail ArgumentError, "Non-coercible value #{val.class}"
      end
    end
  end

  def Reality.country(name)
    page = wp.get(name) or return nil
    # FIXME: not very reliable, as some fictional countries, aliances
    #   and country groups also have this infobox. Or maybe it is acceptable?..
    page.templates(name: 'Infobox country').empty? ? nil : Country.new(page)
  end

  def Reality.countries(*names)
    names = Country.by_continents.keys if names.empty?
    wp.get(*names).map{|page| Country.new(page)}
  end

  def Reality.wp
    Infoboxer.wp
  end
end
