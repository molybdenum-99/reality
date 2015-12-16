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
      infobox.fetch('cctld').text # FIXME: for Ukrane will be {{unbulleted list |[[.ua]] |[[.укр]]}}
    end

    def calling_code
      infobox.fetch('calling_code').text
    end

    def utc_offset
      infobox.fetch('utc_offset').text.sub('−', '-').to_i
    end

    def currency
      infobox.fetch('currency').lookup(:Wikilink).first
    end

    def area
      Reality::Measure(infobox.fetch('area_km2').text.gsub(',', '').to_i, 'km²')
    end

    def population
      Reality::Measure(infobox.fetch('population_estimate').text.gsub(',', '').to_i, 'person')
    end

    def leaders
      titles = infobox.fetch(/^leader_title\d/).map(&:text_)
      names = infobox.fetch(/^leader_name\d/).map{|v| v.lookup(:Wikilink).first}
      titles.zip(names).to_h
    end

    def to_s
      name
    end

    def inspect
      "#<#{self.class}(#{name})>"
    end

    private

    attr_reader :page

    def infobox
      page.infobox
    end
  end

  def Reality.country(name)
    page = wp.get(name)
    # FIXME: not very reliable, as some fictional countries, aliances
    #   and country groups also have this infobox. Or maybe it is acceptable?..
    page.templates(name: 'Infobox country').empty? ? nil : Country.new(page)
  end

  def Reality.wp
    Infoboxer.wp
  end
end
