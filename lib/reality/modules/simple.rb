require 'time_math'

module Reality
  # @private
  module Modules
    module Alive
      Modules.register(self, &:birthday)

      def alive?
        date_of_death.nil?
      end

      def dead?
        !date_of_death.nil?
      end
    end

    module Age
      Modules.register(self) { birthday || created_at || published_at }

      def age_at(tm)
        from = birthday || created_at || published_at
        TimeMath.year.measure(from.to_time, tm.to_time)
      end

      def age
        age_at(Date.today)
      end
    end

    module CountriesByContinent
      Modules.register(self) { wikipage.infobox && wikipage.infobox.name =~ /^infobox continent$/i }

      def countries
        @countries ||= Dictionaries.countries_by_continent(name)
      end
    end

    module CitiesByCountry
      Modules.register(self) { wikipage.infobox && wikipage.infobox.name =~ /^infobox country$/i }

      def cities
        @cities ||= Dictionaries.cities_by_country(name)
      end
    end
  end
end
