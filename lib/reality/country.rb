# NB: all of this is early drafts, so may look naive and sub-optimal.
# Just stay tuned!

module Reality
  class Country < Entity
    class List
      def initialize(*names)
        @names = names
      end

      def count
        @names.count
      end

      def first(n = nil)
        res = get(*@names.first(n || 1))
        n ? res : res.first
      end

      def last(n = nil)
        res = get(*@names.last(n || 1))
        n ? res : res.first
      end

      def sample(n = nil)
        res = get(*@names.sample(n || 1))
        n ? res : res.first
      end

      def each(&block)
        @pages = get(*@names)
        @pages.each(&block)
      end

      include Enumerable

      def to_a
        get(*@names)
      end

      def where(**filters)
        names = @names & Reality::Country.
          by_continents.
          select{|k, v| v == filters[:continent]}.
          map(&:first)
          
        self.class.new(*names)
      end

      private

      def get(*names)
        Reality.wp.get(*names).map{|page| Country.new(page)}
      end
    end
    
    def name
      page.title
    end

    def long_name
      infobox.fetch('conventional_long_name').text.strip
    end

    def capital
      infobox.fetch('capital').lookup(:Wikilink).first
    end

    def languages
      [
        ['Official', infobox_links('official_languages')],
        [infobox.fetch('languages_type').text.sub(/ languages?$/, ''), infobox_links('languages')]
      ].reject{|k, v| k.empty? || v.empty?}.to_h
    end

    def tld
      tlds.first
    end

    def tlds
      infobox_links('cctld').map(&:link)
    end

    def calling_code
      infobox.fetch('calling_code').text.strip
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
      val && Reality::Measure(parse_maybe_scaled(val), 'person')
    end

    def gdp_ppp
      val = infobox.fetch('GDP_PPP').text.strip.sub(/^((Int|US)?\$|USD)/, '')
      val.empty? ? nil : Reality::Measure(parse_scaled(val), '$')
    end

    def gdp_nominal
      val = infobox.fetch('GDP_nominal').text.strip.sub(/^((Int|US)?\$|USD)/, '')
      val.empty? ? nil : Reality::Measure(parse_scaled(val), '$')
    end

    alias_method :gdp, :gdp_nominal

    def leaders
      titles = infobox.fetch(/^leader_title\d/).map(&:text_)
      names = infobox.fetch(/^leader_name\d/).map{|v| v.lookup(:Wikilink).first}
      titles.zip(names).to_h
    end

    def coord
      fetch_coord_dms
    end

    def continent
      self.class.by_continents[page.title]
    end

    def organizations
      organizations_list.map{|o| o[:name]}
    end

    def member_of?(org)
      organizations_list.any?{|o| o[:name] == org || o[:abbr] == org}
    end

    PROPERTIES = %i[
                    continent name long_name
                    tld tlds calling_code utc_offset
                    capital languages currency
                    leaders area population
                    gdp_ppp gdp_nominal
                    organizations
                  ]

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

      def organizations
        @organizations ||= YAML.load(File.read(File.expand_path('../../../data/country_orgs.yaml', __FILE__)))
      end
    end

    private

    def organizations_list
      catnames = page.categories.map(&:name)
      self.class.organizations.select{|o| catnames.include?(o[:category])}
    end
  end

  def Reality.country(name)
    page = wp.get(name) or return nil
    # FIXME: not very reliable, as some fictional countries, aliances
    #   and country groups also have this infobox. Or maybe it is acceptable?..
    page.templates(name: 'Infobox country').empty? ? nil : Country.new(page)
  end

  def Reality.countries(*names)
    names = Country.by_continents.keys.sort if names.empty?
    Country::List.new(*names)
  end

  def Reality.wp
    @wp ||= Infoboxer.wp # while Infoboxer recreates wp for each request
  end
end
