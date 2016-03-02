module Reality
  module Person
    extend Entity::WikipediaType

    infobox_name 'Infobox person'

    # Singular artists, like Bjork or David Bowie
    # TODO: should not repeat code from musical artist, but include it from module?
    parse :albums, [:entity] do |page|
      if (sec = page.sections('Discography').first)
        sec.lookup(:UnorderedList).first.lookup(:Wikilink, :italic?)
      else
        nil
      end
    end
  end
end
