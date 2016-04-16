module Reality
  # @private
  module Character
    extend Entity::WikipediaType

    infobox_name 'Infobox character'

    # FIXME: Both should be auto-parsed
    infobox 'species', :species, :entity,
            parse: ->(var){var.lookup(:Wikilink).first}
            
    infobox 'affiliation', :affiliations, [:entity],
            parse: ->(var){var.lookup(:Wikilink)}

    infobox 'portrayer', :portrayer, :entity,
            parse: ->(var){var.lookup(:Wikilink).first}
  end
end
