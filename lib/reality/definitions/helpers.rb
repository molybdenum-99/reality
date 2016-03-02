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
      birthday && TimeBoots.year.measure(birthday, tm)
    end

    def age
      age_at(Date.today)
    end
  end

  Reality::Entity.include Helpers
end
