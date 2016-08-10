module Reality
  # @private
  module Extensions
    module Alive
      extend Reality::Entity::Extension

      condition { |e| e.birthday } # TODO: calculate in entity context

      def alive?
        date_of_death.nil?
      end

      def dead?
        !date_of_death.nil?
      end
    end

    module Age
      extend Reality::Entity::Extension

      condition { |e| e.birthday || e.created_at || e.published_at }

      def age_at(tm)
        # TimeBoots fail with Time vs Date :(
        #birthday && TimeBoots.year.measure(birthday, tm)

        from = birthday || created_at || published_at

        if from.month < tm.month || from.month == tm.month && from.day <= tm.day
          tm.year - from.year
        else
          tm.year - from.year - 1
        end
      end

      def age
        age_at(Date.today)
      end
    end

    module CountriesByContinent
      extend Reality::Entity::Extension

      condition { |e| e.wikipage.infobox.name =~ /^infobox continent$/i }

      def countries
        @countries ||= Dictionaries.countries_by_continent(name)
      end
    end

    module CitiesByCountry
      extend Reality::Entity::Extension

      condition { |e| e.wikipage.infobox.name =~ /^infobox country$/i }

      def cities
        @cities ||= Dictionaries.cities_by_country(name)
      end
    end
  end
end
