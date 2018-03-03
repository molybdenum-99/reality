module Reality
  module Coerce
    module_function

    def geo_coord(value)
      case value
      when Array # TODO: Array of size 2 exactly
        Geo::Coord.new(*value)
      when Geo::Coord
        value
      when Entity
        (value['coordinates'] || value['coordinate location'])&.value
      when /^\d+(?:\.\d+)?[,\| ;]\s*\d+(?:\.\d+)?$/
        Geo::Coord.new(*value.split(/[,\| ;]\s*/, 2))
      else
        uncoercible(value, Geo::Coord)
      end
    end

    def media_wiki_category(value, infoboxer)
      # TODO:
      # * entities
      # * consider localized category names, available through infoboxer
      case value
      when Link
        value.source == prefix or fail ArgumentError, "Wrong source #{c.source}"
        match = value.match(/^category:(.+)$/i) or
          fail ArgumentError, "Wrong MediaWiki page (not a category) #{c.id}"
        match[1]
      when String
        value.sub(/^category:/i, '')
      else
        uncoercible(value, "Category of #{infoboxer}")
      end.yield_self { |s| "Category:#{s}" }
    end

    def osm_id(value)
      # FIXME: Very temp & naive, no validations
      case value
      when Entity
        if object.uri.start_with?('osm:')
          value.uri.sub(/^osm:/, '')
        else
          value['coordinates'] || value['coordinate location']
        end
      when Link
        if value.source == 'osm'
          value.id
        else
          value.load.yield_self { |entity|
            entity['coordinates'] || entity['coordinate location']
          }
        end
      else
        geo_coord(value)
        # uncoercible value, "OpenStreetMap object"
      end
    end

    private_class_method

    def uncoercible(value, target)
        fail ArgumentError, "Can't coerce #{value} to #{target}"
    end
  end
end