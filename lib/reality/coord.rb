module Reality
  class Coord < Geo::Coord
    def timezone
      Util.require_optional('wheretz', 'Please install `wheretz` gem in order to have offline timezones')
      WhereTZ.get(lat, lng)
    end
  end
end
