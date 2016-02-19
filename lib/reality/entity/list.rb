module Reality
  class EntityList
    attr_reader :names
    
    def initialize(*names)
      @names = names
    end

    def count
      @names.count
    end

    def all
      [*Infoboxer.wikipedia.get(*names)].
        zip(names).map{|page, name|
          Entity.new(name, wikipage: page, wikidata: Wikidata::Entity.fetch(page.title))
        }
    end
  end
end
