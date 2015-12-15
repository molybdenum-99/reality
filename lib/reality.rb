require 'infoboxer'

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
