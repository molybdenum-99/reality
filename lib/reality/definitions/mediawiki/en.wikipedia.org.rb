module Reality
  module Definitions
    module MediaWiki
      define do
        infobox 'Infobox continent',
                     'Infobox Continent' do # FIXME: Infoboxer is a bit dumb about this

          infobox_field 'area', :area, :measure, unit: 'km²',
            parse: ->(var){
              str = var.children.
                templates(name: /^Convert$/i). # Infoboxer is dumb here, tooo :(
                fetch('1').text

              str = var.children.text if str.empty?
              Util::Parse.scaled_number(str)
            }
        end

        infobox 'Infobox country' do
          infobox_field 'conventional_long_name', :long_name, :string
          infobox_field 'area_km2', :area, :measure, unit: 'km²'

          infobox_field 'GDP_PPP', :gdp_ppp, :measure, unit: '$',
                   parse: ->(var){
                     str = var.text.strip.sub(/^((Int|US)?\$|USD)/, '')
                     Util::Parse.scaled_number(str)
                   }

          infobox_field 'population_census', :population, :measure, unit: 'person'
          infobox_field 'population_estimate', :population, :measure, unit: 'person'
        end

        infobox 'Infobox settlement',
                'Infobox city Japan',
                'Infobox Russian city', 'Infobox Russian town',
                'Infobox Russian inhabited locality',
                'Infobox Russian federal subject' do

          infobox_field 'name', :long_name, :string

          infobox_field 'area_km2', :area, :measure, unit: 'km²'
          infobox_field 'area_total_km2', :area, :measure, unit: 'km²'

          infobox_field 'population_total', :population, :measure, unit: 'person'
          infobox_field 'population_metro', :population_metro, :measure, unit: 'person'
        end

        infobox 'Infobox character' do
          # FIXME: Both should be auto-parsed
          infobox_field 'species', :species, :entity,
                  parse: ->(var){var.lookup(:Wikilink).first}

          infobox_field 'affiliation', :affiliations, [:entity],
                  parse: ->(var){var.lookup(:Wikilink)}

          infobox_field 'portrayer', :portrayer, :entity,
                  parse: ->(var){var.lookup(:Wikilink).first}
        end

        parser :albums, [:entity] do |page|
          sec = page.sections('Discography').first or next
          sec.lookup(:UnorderedList).first.lookup(:Wikilink, :italic?)
        end
      end
    end
  end
end
