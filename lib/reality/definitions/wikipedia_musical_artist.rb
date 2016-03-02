module Reality
  module MusicalArtist
    extend Entity::WikipediaType

    infobox_name 'Infobox musical artist'

    parse :albums, [:entity] do |page|
      if (sec = page.sections('Discography').first)
        sec.lookup(:UnorderedList).first.lookup(:Wikilink, :italic?)
      else
        nil
      end
    end
  end
end
