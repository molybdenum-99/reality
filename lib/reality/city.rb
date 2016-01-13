module Reality
  class City < Entity
    def name
      page.title
    end

    def long_name
      infobox.fetch('name').text.strip
    end

    def utc_offset
      infobox.fetch(/^utc_offset(1)?/).text.sub('−', '-').to_i
    end

    def population
      fetch_named_measure('population_total', 'person')
    end

    def population_metro
      fetch_named_measure('population_metro', 'person')
    end

    def area
      fetch_named_measure('area_total_km2', 'km²')
    end

    def country
      # TODO1: convert to "incomplete entry" of type Country
      # TODO2: can be {{UKR}}
      infobox.fetch(/^subdivision_name/).sort_by(&:name).first.children.first
    end

    def coord
      fetch_coord_dms
    end
  end

  def Reality.city(name)
    page = wp.get(name) or return nil
    
    # FIXME?
    page.templates(name: 'Infobox settlement').empty? ? nil : City.new(page)
  end
end
