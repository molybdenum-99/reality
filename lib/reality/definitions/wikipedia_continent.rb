module Reality
  # @private
  module Continent
    extend Entity::WikipediaType

    infobox_name 'Infobox continent', 'Infobox Continent' # FIXME: Infoboxer is a bit dumb about this

    infobox 'area', :area, :measure, unit: 'km²',
      parse: ->(var){
        str = var.children.
          templates(name: /^Convert$/i). # Infoboxer is dumb here, tooo :(
          fetch('1').text

        str = var.children.text if str.empty?
        Util::Parse.scaled_number(str)
      }

    def countries
      @countries ||= Dictionaries.countries_by_continent(name)
    end
  end
end
