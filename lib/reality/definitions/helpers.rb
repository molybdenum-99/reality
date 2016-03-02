require 'time_boots'

module Reality
  # Just assorted "cool things", included into all entities
  # Subject to change/refactor
  module Helpers
    def alive?
      !birthday.nil? && date_of_death.nil?
    end

    def dead?
      !date_of_death.nil?
    end

    def age_at(tm)
      # TimeBoots fail with Time vs Date :(
      #birthday && TimeBoots.year.measure(birthday, tm)

      return nil unless birthday

      if birthday.month < tm.month || birthday.month == tm.month && birthday.day <= tm.day
        tm.year - birthday.year
      else
        tm.year - birthday.year - 1
      end
    end

    def age
      age_at(Date.today)
    end
  end

  Reality::Entity.include Helpers
end
