Reality
=======

[![Gem Version](https://badge.fury.io/rb/reality.svg)](http://badge.fury.io/rb/reality)
[![Join the chat at https://gitter.im/molybdenum-99/reality](https://badges.gitter.im/molybdenum-99/reality.svg)](https://gitter.im/molybdenum-99/reality?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**Reality** is experimental Ruby library/set of libraries to provide uniform query access to heterogenous
web API, with accent on real-world knowledge ones. It emphasizes simplicity of data access and
interoperability of data from various sources.

The ultimate goal is to make the world inspectable and computable.

Some demos:

```ruby
require 'reality' # the core library
require 'reality/miracles' # some demo-friendly shortcuts

# wikipedia

# single entry
cm = Reality.wikipedia.get('Chiang Mai')
# => #<Reality::Entity wikipedia:en://Chiang Mai>

cm.describe
# => #<Reality::Entity wikipedia:en://Chiang Mai>
#                   meta.title: Chiang Mai
#                     meta.url: https://en.wikipedia.org/wiki/Chiang_Mai
#                   meta.image: https://upload.wikimedia.org/wikipedia/commons/7/76/Chiang_Mai_City.png
# ....
#                  native_name: เชียงใหม่
# ....
#             subdivision_type: Country
#             subdivision_name: <wikipedia:en://Thailand>
#            subdivision_type1: <wikipedia:en://Provinces of Thailand (Province)>
#            subdivision_name1: <wikipedia:en://Chiang Mai Province>
#            subdivision_type2: <wikipedia:en://Amphoe>
#            subdivision_name2: <wikipedia:en://Mueang Chiang Mai District (Mueang Chiang Mai)>
#                 leader_title: Mayor
#                  leader_name: Tatsanai Puranupakorn
#               area_total_km2: 40.22km²
#               area_metro_km2: 2,905km²
#             population_as_of: 2017
#             population_total: 131,091people
# ....
#                   utc_offset: +07:00
#                  coordinates: 18°47'43"N 98°59'55"E
# .....

# navigation through data
cm.subdivision_name.describe
# => #<Reality::Entity wikipedia:en://Thailand>
#               meta.title: Thailand
#                 meta.url: https://en.wikipedia.org/wiki/Thailand
#               meta.image: https://upload.wikimedia.org/wikipedia/commons/a/a9/Flag_of_Thailand.svg
#              native_name: {native name:th|ราชอาณาจักรไทย}, {lang:th-Latn|Ratcha-anachak Thai}
#               image_flag: <wikipedia:en://File:Flag of Thailand.svg>
#               image_coat: <wikipedia:en://File:Garuda Emblem of Thailand.svg>
#          national_anthem: <wikipedia:en://Thai National Anthem (Phleng Chat Thai)>, ({lang-en:"Thai National Anthem"}),
#             royal_anthem: <wikipedia:en://Sansoen Phra Barami>, ({lang-en:"Glorify His prestige"}),
#                image_map: <wikipedia:en://File:Location Thailand ASEAN.svg>
# ....
#                  capital: <wikipedia:en://Bangkok>
#              coordinates: 13°45'0"N 100°29'0"E
# ....

# lists of entities
cities = Reality.wikipedia.query(category: 'Cities and towns in Thailand').all
# => [#<Reality::Link wikipedia:en://Amnat Charoen>, #<Reality::Link wikipedia:en://Bueng Kan>, #<Reality::Link wikipedia:en://Buriram>, #<Reality::Link wikipedia:en://Cha-am District>, #<Reality::Link wikipedia:en://Chai Nat>, #<Reality::Link wikipedia:en://Chai Prakan>, #<Reality::Link wikipedia:en://Chaiyaphum>, #<Reality::Link wikipedia:en://Chiang Dao Subdistrict>, #<Reality::Link wikipedia:en://Chiang Mai>, ...
cities.first.population_total
# => #<Reality::Measure 26,118 people>

# Wikidata (structured Wikipedia-alike data storage)
cm2 = Reality.wikidata.query(label: 'Chiang Mai').first
# => #<Reality::Link wikidata://Q52028 (Chiang Mai)>
cm2.describe
# => #<Reality::Entity wikidata://Q52028>
#                                  meta.id: Q52028
#                               meta.label: Chiang Mai
#                         meta.description: city in Chiang Mai province, Thailand
#  ...
#                              instance of: <wikidata://Q15141632 (Thesaban Nakhon)>, <wikidata://Q1549591 (big city)>
#  ...
#                              sister city: <wikidata://Q819613 (Uozu)>, <wikidata://Q128186 (Saitama Prefecture)>, <wikidata://Q182852 (Kunming)>, <wikidata://Q42956 (Harbin)>
#                              GeoNames ID: 1153671
#            category for people born here: <wikidata://Q8078994>
# category for films shot at this location: <wikidata://Q7140299 (Category:Films shot in Chiang Mai)>
#        category for people who died here: <wikidata://Q27062063>
#        Encyclopædia Britannica Online ID: place/Chiang-Mai
# ...

# Interaction Wikipedia→Wikidata:
cm = Reality.wikipedia.get('Chiang Mai')
cm['meta.wikidata'].load.describe
# => #<Reality::Entity wikidata://Q52028>
#    meta.id: Q52028
# meta.title: Q52028
# meta.label: Chiang Mai
# ...

# Wikipedia→OpenStreetMap
Reality.osm.query(around: cm, radius: 30_000, aerodrome: 'international').all
# => [#<Reality::Link osm://way(90429204) (Chiang Mai International Airport)>]

# Wikipedia→OpenWeatherMap
Reality.open_weather_map.query(at: cm).first.describe
# => #<Reality::Entity openweathermap://1153671>
#       temp: 33°C
#   pressure: 1,007hPa
#   humidity: 55%
#   temp_min: 33°C
#   temp_max: 33°C
# visibility: 10000
# wind_speed: 4.6m/s
#   wind_deg: 160°
# clouds_all: 40
#  timestamp: 2018-05-27 13:00:00 +0300
#    country: TH
#    sunrise: 2018-05-27 01:46:48 +0300
#     sunset: 2018-05-27 14:55:42 +0300
#       name: Chiang Mai
#      coord: 18°48'0"N 99°0'0"E
```

**!!!IMPORTANT!!!** This is **pre-release** of new, completely rewritten version. Previos version
turned to be a (nice-looking) dead end. It still can be found at [old-prototype](https://github.com/molybdenum-99/reality/tree/old-prototype-branch)
branch, and installed as a gem version 0.0.5.

Current state is very WIP subject to lot of changes

See also the explanatory [presentation](https://docs.google.com/presentation/d/1I4mznHUBhVVDxWfO2DRzxP4wNhs9Mmtx09SizLqIbaE/edit?usp=sharing)
and [video](https://www.youtube.com/watch?v=x9GePP3B0oE), made at RubyConfIndia 2018.

Stay tuned for large and important updates!

## Credits

* [Victor Shepelev](https://zverok.github.io) [@zverok](https://github.com/zverok);
* Sergii Mostovyi [@smostovoy](https://github.com/smostovoy);
* [Valentino Stoll](http://www.awesomevibe.com/) [@codenamev](https://github.com/codenamev);
* [Several great contributors](https://github.com/molybdenum-99/reality/graphs/contributors).

Development of first version was sponsored by
[2015 Ruby Association Grant](http://www.ruby.or.jp/en/news/20160406.html).

Initial idea is inspired by "integrated data" of
[Wolfram Language](http://reference.wolfram.com/language/).

## License

[MIT](https://github.com/molybdenum-99/reality/blob/master/LICENSE.txt)
