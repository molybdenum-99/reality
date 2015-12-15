require 'infoboxer'

module Reality
  class Country
    def initialize(page)
      @page = page
    end

    def name
      @page.title
    end

    def long_name
      @page.infobox.fetch('conventional_long_name').text
    end

    def to_s
      name
    end

    def inspect
      "#<#{self.class}(#{name})>"
    end
  end

  def Reality.country(name)
    page = wp.get(name)
    page.templates(name: 'Infobox country').empty? ? nil : Country.new(page)
  end

  def Reality.wp
    Infoboxer.wp
  end
end
