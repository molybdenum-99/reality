Reality
=======

[![Gem Version](https://badge.fury.io/rb/reality.svg)](http://badge.fury.io/rb/reality)
[![Join the chat at https://gitter.im/molybdenum-99/reality](https://badges.gitter.im/molybdenum-99/reality.svg)](https://gitter.im/molybdenum-99/reality?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**Reality** is your quick access point to almost any entity existing in
real world (and described in Wikipedia). Its goal is to make the world
inspectable and computable.

```ruby
# Like this
require 'reality'
include Reality::Methods

ar = Entity('Argentina')
ar.cities.load!
#  => #<Reality::List[Buenos Aires, "Córdoba, Argentina", "Rosario, Santa Fe", "Mendoza, Argentina", La Plata, San Miguel de Tucumán, Mar del Plata, Salta, "Santa Fe, Argentina", "San Juan, Argentina", "Resistencia, Chaco", Neuquén, Santiago del Estero, Corrientes, Avellaneda, Bahía Blanca, San Salvador de Jujuy, Quilmes, Lanús, Comodoro Rivadavia, "Concordia, Entre Ríos"]>
ar.cities.map{|city| city.coord.distance_to(ar.capital)}
# => [#<Reality::Measure(0.0 km)>, #<Reality::Measure(646 km)>, #<Reality::Measure(278 km)>, #<Reality::Measure(985 km)>, #<Reality::Measure(54 km)>, #<Reality::Measure(1,084 km)>, #<Reality::Measure(385 km)>, #<Reality::Measure(1,285 km)>, #<Reality::Measure(394 km)>, #<Reality::Measure(1,005 km)>, #<Reality::Measure(797 km)>, #<Reality::Measure(987 km)>, #<Reality::Measure(942 km)>, #<Reality::Measure(793 km)>, #<Reality::Measure(7 km)>, #<Reality::Measure(574 km)>, #<Reality::Measure(1,338 km)>, #<Reality::Measure(16 km)>, #<Reality::Measure(11 km)>, #<Reality::Measure(1,471 km)>, #<Reality::Measure(358 km)>] 

# or this
matz = Entity('Yukihiro Matsumoto')
# => #<Reality::Entity(Yukihiro Matsumoto):person>
matz.describe
# ---------------------------------------------
# #<Reality::Entity(Yukihiro Matsumoto):person>
# ---------------------------------------------
#      awards: #<Reality::List[FSF Free Software Awards?]>
# birth_place: #<Reality::Entity?(Ōsaka Prefecture)>
#    birthday: #<Date: 1965-04-14>
# citizenship: #<Reality::Entity?(Japan)>
# occupations: ["scientist", "engineer", "computer scientist", "programmer"]
#         sex: "male"

matz.birth_place.population
# => #<Reality::Measure(8,847,838 person)>
matz.birth_place.neighbours.map(&:population)
# => [#<Reality::Measure(2,610,073 person)>, #<Reality::Measure(5,522,917 person)>, #<Reality::Measure(1,372,046 person)>, #<Reality::Measure(961,320 person)>, #<Reality::Measure(119,291 person)>]
matz.birth_place.coord.weather
# => #<Reality::Weather(-0.91°C, Clear)>

# or maybe this?
beatles = Entity('Beatles').parts
# => #<Reality::List[John Lennon?, Sir. Paul McCartney?, Ringo Starr?, George Harrison?, Stuart Sutcliffe?, Pete Best?]>
beatles.load!
beatles.select(&:alive?)
# => #<Reality::List[Paul McCartney, Ringo Starr, Pete Best]> 
beatles.select(&:alive?).map{|beatle| beatle.albums && beatle.albums.last}
# => [#<Reality::Entity?(New (album))>, #<Reality::Entity?(Old Wave)>, nil]

# and stuff
titanic = Entity('Titanic (1997 film)')
titanic.actors.each do |actor|
  puts "#{ actor.name }: #{ actor.age_at(titanic.published_at) }"
end
# Frances Fisher: 45
# Leonardo DiCaprio: 22
# Danny Nucci: 29
# Bill Paxton: 42
# Gloria Stuart: 87
# Kate Winslet: 22
# Billy Zane: 31
# ......
```

## Is it real? Is it really working?.. But how?

Yes. Every example you can see above is working. And many other things
are working. And almost _any_ thing which Wikipedia knows about, can be
loaded through **Reality**, and somehow inspected and used and navigated
to next entities and measured and ...

For any entity (or list of entities) you request, it will do:
* query English Wikipedia for this entity by name;
* gather data from Wikipedia **and** Wikidata, by several parsing rules
  (the list of them is growing every day);
* present you with `Entity` object with ton of useful methods.

Above this core functionality, **Reality** also does:
* allow you to navigate through entity and linked entities and lists of
  them;
* provide some (simple, but pretty looking) value classes like "amount
  with units" (see distances and populations above), "geo coordinates",
  "timezone offset" and so on;
* mix some other services (few for now, dozens in future) into those
  value types, like `Geo::Coord#weather` through OpenWeatherMap and
  so on.

Eventually, **Reality**, following its pretentious name, plans to interconnect
multiple open data sources (all of them!) into easily navigable and usable
graph of Ruby objects. Or something like that.

## Why/when do I need this?..

Let's start from when you _don't_ need this.

Reality is not incredibly precise and realiable: for example, as you can
see in first example above, it lists only top cities of country, not all
of them (in fact, it is contents of Wikipedia page "List of cities in
%countryname%"). The data is only as good as data in Wikipedia/Wikidata
**and** our parsers/processors for this data. So, don't try to use
it for really precise scientific computations or really important business
tasks.

But! Data there is, and already a lot of it, and it will be a lot _moar_
in near future. So, feel free and happy to use Reality for:
* teaching Ruby and data processing on _real and actual_ data;
* use interesting data for experiments, quick scripts and insights about
  errrm reality;
* demonstrating some tools for data processing and/or visualisation on
  variative and intersting examples;
* initial seeding of development databases with countries, cities, genres,
  dates, coordinates and so on;
* ...your option?..

## Uhm, ok. How to use it?

First, install the gem as usual (it is on rubygems, and named "reality"),
using Gemfile/`bundle install` or `gem install reality`.

Second, `require "reality"` or use interactive console with the same name.

Now, to Reality concepts.

### Entity

Now you can use `Reality::Entity`, which is core concept:

```ruby
ar = Reality::Entity('Argentina')
# => #<Reality::Entity(Argentina):country>

ar.describe # shows all fields entity have
# -------------------------------------
# #<Reality::Entity(Argentina):country>
# -------------------------------------
# adm_divisions: #<Reality::List[Buenos Aires?, Buenos Aires Province?, Catamarca Province?, Chaco Province?, Corrientes?, Córdoba Province?, Formosa Province?, Entre Ríos Provinces?, Jujuy Province?, La Pampa Province?, La Rioja Province?, Mendoza Province?, Misiones Province?, Neuquén Province?, Río Negro Province?, Salta Province?, San Juan Province?, San Luis Province?, Santa Cruz Province?, Santa Fe Province?, Santiago del Estero Province?, Tucumán Province?, Tierra del Fuego Province?]>
#          area: #<Reality::Measure(2,780,400 km²)>
#  calling_code: "+54"
#       capital: #<Reality::Entity?(Buenos Aires)>
#     continent: #<Reality::Entity?(South America)>
#         coord: #<Reality::Geo::Coord(34°0′0″S,64°0′0″W)>
#       country: #<Reality::Entity?(Argentina)>
#    created_at: #<Date: 1816-01-01>
#      currency: #<Reality::Entity?(peso)>
#   gdp_nominal: #<Reality::Measure(537,659,972,702 $)>
#       gdp_ppp: #<Reality::Measure(964,279,000,000 $)>
# head_of_state: #<Reality::Entity?(Mauricio Macri)>
# highest_point: #<Reality::Entity?(Aconcagua)>
#     iso2_code: "AR"
#     iso3_code: "ARG"
#     long_name: "Argentine Republic"
#    neighbours: #<Reality::List[Uruguay?, Brazil?, Chile?, Paraguay?, Bolivia?]>
# organizations: #<Reality::List[United Nations?, Union of South American Nations?, Mercosur?, World Trade Organization?, G-20 major economies?, Central American Bank for Economic Integration?, International Bank for Reconstruction and Development?, African Development Bank?, Andean Community of Nations?, International Finance Corporation?, Australia Group?, International Development Association?, International Centre for Settlement of Investment Disputes?, Multilateral Investment Guarantee Agency?, Agency for the Prohibition of Nuclear Weapons in Latin America and the Caribbean?]>
#       part_of: #<Reality::List[Latin America?]>
#    population: #<Reality::Measure(43,417,000 person)>
#           tld: ".ar"
#     tz_offset: #<Reality::TZOffset(UTC-03:00)>

# all those fields are exposed as methods:
p ar.population
# => #<Reality::Measure(43,417,000 person)>

# those which are entities could be navigated further:
ar.capital.describe
# -------------------------------------
# #<Reality::Entity(Buenos Aires):city>
# -------------------------------------
#    adm_divisions: #<Reality::List[Villa Devoto?, Agronomía?, "Retiro, Buenos Aires"?, "Caballito, Buenos Aires"?, "Chacarita, Buenos Aires"?, Parque Avellaneda?, "Villa Real, Buenos Aires"?, Flores?, Vélez Sársfield?, "Versalles, Buenos Aires"?, "Saavedra, Buenos Aires"?, "Barracas manda , Buenos Aires"?, La Boca?, Villa Lugano?, Villa del Parque?, Villa Luro?, Puerto Madero?, Balvanera?, Belgrano?, Boedo?, "Recoleta, Buenos Aires"?, Palermo?, Villa General Mitre?, Villa Riachuelo?, Villa Pueyrredón?, "San Telmo, Buenos Aires"?, Villa Urquiza?, Villa Santa Rita?, Villa Ortúzar?, "Monserrat, Buenos Aires"?, "Coghlan, Buenos Aires"?, Colegiales?, Parque Chacabuco?, Mataderos?, Constitución?, "Floresta, Buenos Aires"?, Villa Crespo?, Villa Soldati?, "La Paternal, Buenos Aires"?, Liniers?, Monte Castro?, Nueva Pompeya?, San Nicolás?, "Núñez, Buenos Aires"?, Parque Chas?, Parque Patricios?, San Cristóbal?, "Almagro, Buenos Aires"?]>
#             area: #<Reality::Measure(203 km²)>
#            coord: #<Reality::Geo::Coord(34°35′58″S,58°22′54″W)>
#          country: #<Reality::Entity?(Argentina)>
#       created_at: #<Date: 1580-06-21>
#        elevation: #<Reality::Measure(25 m)>
#        long_name: "Autonomous City of Buenos Aires"
#       neighbours: #<Reality::List[Buenos Aires Province?]>
#       population: #<Reality::Measure(2,890,151 person)>
# population_metro: #<Reality::Measure(12,741,364 person)>
#        tz_offset: #<Reality::TZOffset(UTC-03:00)>
```

#### Entity loading

When you see something like
`#<Reality::Entity?(Mauricio Macri)>` it means "not loaded entity" (like
link or reference). Entity can be loaded explicitly via `load!` method,
or implicitly on `method_missing` or `describe` call.

```ruby
ar.head_of_state
# => #<Reality::Entity?(Mauricio Macri)>
ar.head_of_state.loaded?
# => false 
ar.head_of_state.describe
# ----------------------------------
# #<Reality::Entity(Mauricio Macri)>
# ----------------------------------
# birth_place: #<Reality::Entity?(Tandil)>
#    birthday: #<Date: 1959-02-08>
# citizenship: #<Reality::Entity?(Argentina)>
#      father: #<Reality::Entity?(Francisco Macri)>
#  given_name: "Mauricio"
# occupations: ["businessperson", "politician", "civil engineer"]
#    position: "President of Argentina"
#         sex: "male"
#      spouse: #<Reality::Entity?(Juliana Awada)>
ar.head_of_state.loaded?
# => true 
```

#### Entity naming

Currently, reality loads entities just by _Wikipedia page name_ (and
respects redirects the same way Wikipedia does). So, for example:

```ruby
# cool:
Reality::Entity('Einstein')
# => #<Reality::Entity(Albert Einstein)>

# but...
Reality::Entity('Ruby') # => about mineral
Reality::Entity('Ruby (programming language)') # => about programming language
```

Further Reality versions would at least work smarter with disambiguation
pages and "other uses" link. But currently, that's just what you have.

#### Entity additional types

Let's look at this again:

```ruby
ar = Reality::Entity('Argentina')
# => #<Reality::Entity(Argentina):country>
```

Final `:country` part means Reality "guessed" desired object type (by
Wikipedia infobox name) and used this to parse additional properties from
Wikipedia, and also add some useful methods. For example (as seen above):

```ruby
ar.cities
# => #<Reality::List[Buenos Aires?, "Córdoba, Argentina"?, "Rosario, Santa Fe"?, "Mendoza, Argentina"?, La Plata?, San Miguel de Tucumán?, Mar del Plata?, Salta?, "Santa Fe, Argentina"?, "San Juan, Argentina"?, "Resistencia, Chaco"?, Neuquén?, Santiago del Estero?, Corrientes?, Avellaneda?, Bahía Blanca?, San Salvador de Jujuy?, Quilmes?, Lanús?, Comodoro Rivadavia?, "Concordia, Entre Ríos"?]> 
```

It is not a property parsed on entry loading (so, it will not be seen
in `#describe`), but helpful method, which fetched additional data from
Wikipedia. (Unfortunately, there are no way to know which "helpful methods"
were added with current entity type, except for scanning `entity.methdods`
by eyes.)

Also, you should note there are some quirks about this "guess by infobox"
thing. For ex:

```ruby
# ok
Reality::Entity('Buenos Aires')
# => #<Reality::Entity(Buenos Aires):city>

# not ok: note no "additional type" :city
l = Reality::Entity('Lyon')
# => #<Reality::Entity(Lyon)>
# thats because of:
l.wikipage.infobox.name
# => "Infobox French commune"
```

This will become better in future.

#### Entity internals

Each entity has `wikipage` and `wikidata` methods, containing data loaded
from Wikipedia and Wikidata respectively. While `wikidata` is pretty ugly
internal object, `wikipage` CAN be useful on its own: it is an instance
of [Infoboxer::MediaWiki::Page](http://www.rubydoc.info/gems/infoboxer/Infoboxer/MediaWiki/Page)
and quite sophisticated and useful object:

```ruby
ruby = Reality::Entity('Ruby (programming language)')
puts ruby.wikipage.intro
# Ruby is a dynamic, reflective, object-oriented, general-purpose programming language....
ruby.wikipage.sections
# => [#<Section(level: 2, heading: "History"): ...>, #<Section(level: 2, heading: "Table of versions"): ...>, #<Section(level: 2, heading: "Philosophy"): ...>, ...and so on
```

### Lists

Let's look closer at this part:

```ruby
ar.neighbours
# => #<Reality::List[Uruguay?, Brazil?, Chile?, Paraguay?, Bolivia?]>
```

`Reality::List` is just array of entities, with some useful differences.
For example, it provides more concise output (compare with
`ar.neighbours.to_a` on your own). It also provides ability to batch-load
all entities in list:

```ruby
# instead of:
# ar.neighbours.each(&:load!)
# ...which will be 5 separate requests to Wikipedia and 5 to Wikidata
# ...you can write:
ar.neighbours.load!
# ...which is 1 request to Wikipedia API and 1 to Wikidata
```

And last, for list of loaded entities, it provides pretty `#describe`
method to quickly look inside:

```ruby
ar.neighbours.describe
# -------------------------
# #<Reality::List(5 items)>
# -------------------------
#   keys: adm_divisions (5), area (5), calling_code (5), capital (5), continent (5), coord (5), country (5), created_at (5), currency (5), follows (1), gdp_nominal (5), gdp_ppp (5), head_of_state (5), highest_point (5), iso2_code (5), iso3_code (5), long_name (5), neighbours (5), organizations (5), part_of (5), population (5), tld (5), tz_offset (5)
#  types: country (5)
```

(OK, not incredibly useful for now, but provides you with some insights
on "what's inside".)

Finally, there are some (will be more in future) "default lists" in Reality:

```ruby
Reality.countries
# => #<Reality::List[Algeria?, Angola?, Benin?, Botswana?, Burkina Faso?, Burundi?, Cameroon?, Cape Verde?, Central African Republic?, Chad?, Comoros?, Republic of the Congo?, Democratic Republic of the Congo?, Djibouti?, Egypt?, Equatorial Guinea?, Eritrea?, Ethiopia?, Gabon?, Gambia?, Ghana?, Guinea?, Guinea-Bissau?, Ivory Coast?, Kenya?, Lesotho?, Liberia?, Libya?, Madagascar?, Malawi?, Mali?, Mauritania?, Mauritius?, Morocco?, Mozambique?, Namibia?, Niger?, Nigeria?, Rwanda?, São Tomé and Príncipe?, Senegal?, Seychelles?, Sierra Leone?, Somalia?, South Africa?, South Sudan?, Sudan?, Swaziland?, Tanzania?, Togo?, Tunisia?, Uganda?, Zambia?, Zimbabwe?, Afghanistan?, Armenia?, Azerbaijan?, Bahrain?, Bangladesh?, Bhutan?, Brunei?, Cambodia?, China?, Cyprus?, East Timor?, Georgia (country)?, India?, Indonesia?, Iran?, Iraq?, Israel?, Japan?, Jordan?, Kazakhstan?, Kuwait?, Kyrgyzstan?, Laos?, Lebanon?, Malaysia?, Maldives?, Mongolia?, Myanmar?, Nepal?, North Korea?, Oman?, Pakistan?, State of Palestine?, Philippines?, Qatar?, Saudi Arabia?, Singapore?, South Korea?, Sri Lanka?, Syria?, Tajikistan?, Thailand?, Turkey?, Turkmenistan?, United Arab Emirates?, Uzbekistan?, Vietnam?, Yemen?, Albania?, Andorra?, Austria?, Belarus?, Belgium?, Bosnia and Herzegovina?, Bulgaria?, Croatia?, Czech Republic?, Denmark?, Estonia?, Finland?, France?, Germany?, Greece?, Hungary?, Iceland?, Republic of Ireland?, Italy?, Latvia?, Liechtenstein?, Lithuania?, Luxembourg?, Republic of Macedonia?, Malta?, Moldova?, Monaco?, Montenegro?, Kingdom of the Netherlands?, Norway?, Poland?, Portugal?, Romania?, Russia?, San Marino?, Serbia?, Slovakia?, Slovenia?, Spain?, Sweden?, Switzerland?, Ukraine?, United Kingdom?, Vatican City?, Antigua and Barbuda?, Bahamas?, Barbados?, Belize?, Canada?, Costa Rica?, Cuba?, Dominica?, Dominican Republic?, El Salvador?, Grenada?, Guatemala?, Haiti?, Honduras?, Jamaica?, Mexico?, Nicaragua?, Panama?, Saint Kitts and Nevis?, Saint Lucia?, Saint Vincent and the Grenadines?, Trinidad and Tobago?, United States?, Argentina?, Bolivia?, Brazil?, Chile?, Colombia?, Ecuador?, Guyana?, Paraguay?, Peru?, Suriname?, Uruguay?, Venezuela?, Australia?, Fiji?, Kiribati?, Marshall Islands?, Federated States of Micronesia?, Nauru?, New Zealand?, Palau?, Papua New Guinea?, Samoa?, Solomon Islands?, Tonga?, Tuvalu?, Vanuatu?]>
Reality.continents
# => #<Reality::List[Asia?, Africa?, North America?, South America?, Antarctica?, Europe?, Australia (continent)?]>
```

Though, there is one funny quirk with latter (still thinking of it):

```ruby
Reality.continents.last
# => #<Reality::Entity(Australia (continent)):continent>
Reality.continents.last.countries
# => #<Reality::List[]>
# ????
# Let's see...
a = Reality::Entity('Australia')
# => #<Reality::Entity(Australia):country>
a.continent
# => #<Reality::Entity?(Oceania)>
# Hmmmm....
a.continent.countries
# => #<Reality::List[Australia?, Fiji?, Kiribati?, Marshall Islands?, Federated States of Micronesia?, Nauru?, New Zealand?, Palau?, Papua New Guinea?, Samoa?, Solomon Islands?, Tonga?, Tuvalu?, Vanuatu?]>
```

That's kinda weird thing of Wikipedia data ("Countries by continents" and
"List of continents" pages seems to be vague of "continent" and "part of
world" concepts).

### Helper classes

Currently, there are several of them. All are just "handy wrappers"
around some values, that may be (or may be not) replaced with additional
gems in future versions.

#### Reality::Measure

```ruby
ar.population
# => #<Reality::Measure(43,417,000 person)>
ar.population.amount
# => 43,417,000
ar.population.unit
# => #<Reality::Measure::Unit(person)>
ar.population ** 2
# => #<Reality::Measure(1,885,035,889,000,000 person²)>
ar.population / ar.area
# => #<Reality::Measure(15 person/km²)>

# using on its own:
m = Reality::Measure.new(10, 'm')
# => #<Reality::Measure(10 m)> 
m ** 2
# => #<Reality::Measure(100 m²)>
```

**NB**: No measure conversion provided for now. Attempt to sum metres with
kilometres will fail miserably. [unitwise](https://github.com/joshwlewis/unitwise)
may be utilised instead or inside `Measure` in future.

#### Reality::Geo::Coord

```ruby
ar.capital.coord
# => #<Reality::Geo::Coord(34°35′58″S,58°22′54″W)>
ar.capital.coord.to_s
# => "-34.599722222222,-58.381944444444"
ar.capital.coord.distance_to(ar.highest_point.coord)
# => #<Reality::Measure(1,097 km)>
# ar.capital.coord.distance_to(ar.highest_point) also can be used, if highest_point has coord method
ar.capital.coord.direction_to(ar.highest_point.coord)
# => #<Reality::Measure(278 °)>
```

**NB**: [geokit](https://github.com/geokit/geokit) already somehow
utilized inside.

#### Reality::TZOffset

```ruby
ar.tz_offset
# => #<Reality::TZOffset(UTC-03:00)>
ar.tz_offset.now
# => 2016-03-01 16:03:52 -0300
ar.tz_offset.local(2016, 3, 2, 14, 30)
# => 2016-03-02 14:30:00 -0300
ar.tz_offset.convert(Time.now)
# => 2016-03-01 16:04:36 -0300

# using on its own:
Reality::TZOffset.parse('GMT+1').now
# => 2016-03-01 20:05:10 +0100
```

### Using external services

Currently, there are two external services (except of Wikipedia and
Wikidata) mashed into Reality:
* [OpenWeatherMap](http://openweathermap.org/) for "current weather"
  feature;
* [GeoNames](http://www.geonames.org/) for "timezone at this coordinates"
  feature.

Both of them, unlike Wikipedia/Wikidata API, require free access key
for usage. So, in your own code, you'll see something like this:

```ruby
ar.capital.coord.weather
# KeyError: Expected keys.open_weather_map to exist in config. It is OpenWeatherMap APPID. Can be obtained here: http://openweathermap.org/appid
ar.capital.coord.timezone
# KeyError: Expected keys.geonames to exist in config. It is GeoNames username. Can be received from http://www.geonames.org/login
```

For experiments you can use (but not abuse) Reality demo config, like this:

```ruby
Reality.configure(:demo)
ar.capital.coord.weather
# => #<Reality::Weather(21°C, Clear)>
ar.capital.coord.timezone
# => #<TZInfo::DataTimezone: America/Argentina/Buenos_Aires>
```

For more extensive data usage, you should use `Reality#configure` with
your own config (see `config/demo.yml` for sample of this).

Note, that reality binary is configured with `:demo` by default.

### More

There are several things that are not required by `require "reality"` (but
are included in interactive console).

**Pretty inspect**: `require "reality/pretty_inspect"` redefines `#inspect`
method for some core classes, which are heavily utilized by reality, and
their default `#inspect` is not that pretty. For example:

```ruby
# without pretty_inspect
Reality::Entity('Yukihiro Matsumoto').birthday
# => #<Date: 1965-04-14 ((2438865j,0s,0n),+0s,2299161j)>

# with pretty_inspect
Reality::Entity('Yukihiro Matsumoto').birthday
# => #<Date: 1965-04-14>

# without pretty_inspect
Reality::Entity('Buenos Aires').population / Reality::Entity('London').population
# => (2890151/8416535)
# ↑ it's Rational, pretty precise, but hard to read

# with pretty_inspect
Reality::Entity('Buenos Aires').population / Reality::Entity('London').population
# => 0.3
# ↑ it's still the same Rational, but with less precise/more readable output
```

**Shortcuts**: `require "reality/shortcuts"` provides you with pretty
concise syntax:

```ruby
include Reality

E('Yukihiro Matsumoto')

L('Argentine', 'Bolivia', 'Chile')
```

Also, you could do `include Reality::Methods` (instead of `include Reality`)
in your code to not pollute your namespace with anything except `Entity`
and `List` methods (`E` and `L` is also in this namespace after you
have required "reality/shortcuts").

## Good. What next?..

Reality currently in, let's say "working prototype" state. Many things
work and useful, many others are subject to change/improve. Near and
not-so-near plans looks like this (order is vague):

* more definitions of useful Wikidata/Wikipedia properties and types,
  cleanup and re-checking of existing ones;
* more external datasources ([OpenStreetMap](http://www.openstreetmap.org/)
  one of first candidates) and more info from already included ones;
* more maturity: cleaner code, more tests, docs, config policy....
* powerful and flexible data caching (if you run "study all world capitals"
  script 10 times, or want to do a quick presentation of topic to students,
  you'll be happy that previously quiried data are already on disk);
* large demo-scripts set, maybe in independent repository;
* separation of largely independent parts to another gems and libraries.

## Want to help?

Great!

**Reality** will be glad to accept your issues and pull requests.
Currently, it would be great if somebody lay their hands on:

* thoroughly define more and more Wikidata predicates (and enchance system
  for predicates definition: consider aliases, plural/singular properties
  and so on);
* investigate and define more Wikipedia types (kinds of infoboxes) and
  enchance existing ones;
* connect more external services and integrate them into Reality (for
  example, geocoding: via OpenStreetMap guess city from coordinates
  **and** make this city a `Reality::Entity`);
* play with Reality and share your experiences and examples and problems
  and cool demos!
  
## Credits

* [Victor Shepelev](https://zverok.github.io) [@zverok](https://github.com/zverok);
* Sergey Mostovoy [@smostovoy](https://github.com/smostovoy).

Development sponsored by
[2015 Ruby Association Grant](http://www.ruby.or.jp/en/news/20151116.html).

Initial idea is inspired by "integrated data" of
[Wolfram Language](http://reference.wolfram.com/language/).

## License

[MIT](https://github.com/molybdenum-99/reality/blob/master/LICENSE.txt)
