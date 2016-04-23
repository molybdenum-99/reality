require 'time_boots'

module Reality
  # @private
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

  Reality::Entity.include Helpers
end
