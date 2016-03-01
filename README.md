Reality
=======

**Reality** is your quick access point to almost any entity existing in
real world (and described in Wikipedia). It's goal is to make the world
inspectable and computable.

```ruby
# Like this
ar = entity('Argentina')
ar.cities.load! # Can be omitted, just optimisiation for batch load
#  => #<Reality::Entity::List[Buenos Aires, "Córdoba, Argentina", "Rosario, Santa Fe", "Mendoza, Argentina", La Plata, San Miguel de Tucumán, Mar del Plata, Salta, "Santa Fe, Argentina", "San Juan, Argentina", "Resistencia, Chaco", Neuquén, Santiago del Estero, Corrientes, Avellaneda, Bahía Blanca, San Salvador de Jujuy, Quilmes, Lanús, Comodoro Rivadavia, "Concordia, Entre Ríos"]>
ar.cities.map{|city| city.coord.distance_to(ar.capital)}
# => [#<Reality::Measure(0.0 km)>, #<Reality::Measure(646 km)>, #<Reality::Measure(278 km)>, #<Reality::Measure(985 km)>, #<Reality::Measure(54 km)>, #<Reality::Measure(1,084 km)>, #<Reality::Measure(385 km)>, #<Reality::Measure(1,285 km)>, #<Reality::Measure(394 km)>, #<Reality::Measure(1,005 km)>, #<Reality::Measure(797 km)>, #<Reality::Measure(987 km)>, #<Reality::Measure(942 km)>, #<Reality::Measure(793 km)>, #<Reality::Measure(7 km)>, #<Reality::Measure(574 km)>, #<Reality::Measure(1,338 km)>, #<Reality::Measure(16 km)>, #<Reality::Measure(11 km)>, #<Reality::Measure(1,471 km)>, #<Reality::Measure(358 km)>] 

# or this
matz = entity('Yukihiro Matsumoto')
# => #<Reality::Entity(Yukihiro Matsumoto):person>
matz.describe
# ---------------------------------------------
# #<Reality::Entity(Yukihiro Matsumoto):person>
# ---------------------------------------------
#      awards: #<Reality::Entity::List[FSF Free Software Awards?]>
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
beatles = entity('Beatles').parts
# => #<Reality::Entity::List[John Lennon?, Sir. Paul McCartney?, Ringo Starr?, George Harrison?, Stuart Sutcliffe?, Pete Best?]>
beatles.load!
beatles.select(&:alive?)
# => #<Reality::Entity::List[Paul McCartney, Ringo Starr, Pete Best]> 
beatles.select(&:alive?).map{|beatle| beatle.albums && beatle.albums.last}
# => [#<Reality::Entity?(New (album))>, #<Reality::Entity?(Old Wave)>, nil] 
```

## Is it real? Is it really working?.. But how?

Yes. Every example you can see above are working. And many other things
are working. And almost _any_ thing which Wikipedia knows about, can be
loaded through **Reality**, and somehow inspected and used and navigated
to next entities and measured and ...

For any entity (or list of entities) you request, it will do:
* query English Wikipedia for this entity by name;
* gather data from Wikipedia **and** Wikidata, by several parsing rules
  (the list of them is growing every day);
* present you with `Entity` object with ton of useful methods.

Above this core functionality, **Reality** also does:
* allow you to navigate through entity and try to optimise this
  process;
* provide some (simple, but pretty looking) value classes like "amount
  with units" (see distances and populations above), "geo coordinates",
  "timezone offset" and so on;
* mix some other services (few for now, dozens in future) into those
  value types, like `Geo::Coord#weather` through OpenWeatherMap and
  so on.

Eventually, **Reality**, following its pathetic name, plans to interconnect
multiple open data sources (all of them!) into easily navigable and usable
graph of Ruby objects. Or somethink like that.

## Why/when do I need this?..

Let's start from when you _don't_ need this.

Reality is not incredibly precise and realiable: for example, as you can
see in first example above, it lists only top cities of country, not all
of them (in fact, it is contents of Wikipedia page "List of cities in
%countryname%"). The data is only as good as data in Wikipedia/Wikidata
is, **and** our parsers/processors for this data. So, don't try to use
it for really precise scientific computations or really important business
tasks.

But! Data there is, and already a lot of it, and it will be a lot _moar_
in near future. So, feel free and happy to use Reality for:
* teaching Ruby and data processing on _real and actual_ data;
* use interesting data for experiments, quick scripts and 




## Uhm, ok. How to use it?

First, install the gem as usual (it is on rubygems, and named reality),
using Gemfile/`bundle install` or `gem install reality`.

Second, `require "reality"` or use interactive console with the same name.

Now, to Reality concepts.

### Entity

Now, you can use `Reality::Entity`, which is core concept:

```ruby
ar = Reality::Entity('Argentine')

ar.describe # shows all fields entity have
# -------------------------------------
# #<Reality::Entity(Argentina):country>
# -------------------------------------
# adm_divisions: #<Reality::Entity::List[Buenos Aires?, Buenos Aires Province?, Catamarca Province?, Chaco Province?, Corrientes?, Córdoba Province?, Formosa Province?, Entre Ríos Provinces?, Jujuy Province?, La Pampa Province?, La Rioja Province?, Mendoza Province?, Misiones Province?, Neuquén Province?, Río Negro Province?, Salta Province?, San Juan Province?, San Luis Province?, Santa Cruz Province?, Santa Fe Province?, Santiago del Estero Province?, Tucumán Province?, Tierra del Fuego Province?]>
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
#    neighbours: #<Reality::Entity::List[Uruguay?, Brazil?, Chile?, Paraguay?, Bolivia?]>
# organizations: #<Reality::Entity::List[United Nations?, Union of South American Nations?, Mercosur?, World Trade Organization?, G-20 major economies?, Central American Bank for Economic Integration?, International Bank for Reconstruction and Development?, African Development Bank?, Andean Community of Nations?, International Finance Corporation?, Australia Group?, International Development Association?, International Centre for Settlement of Investment Disputes?, Multilateral Investment Guarantee Agency?, Agency for the Prohibition of Nuclear Weapons in Latin America and the Caribbean?]>
#       part_of: #<Reality::Entity::List[Latin America?]>
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
#    adm_divisions: #<Reality::Entity::List[Villa Devoto?, Agronomía?, "Retiro, Buenos Aires"?, "Caballito, Buenos Aires"?, "Chacarita, Buenos Aires"?, Parque Avellaneda?, "Villa Real, Buenos Aires"?, Flores?, Vélez Sársfield?, "Versalles, Buenos Aires"?, "Saavedra, Buenos Aires"?, "Barracas manda , Buenos Aires"?, La Boca?, Villa Lugano?, Villa del Parque?, Villa Luro?, Puerto Madero?, Balvanera?, Belgrano?, Boedo?, "Recoleta, Buenos Aires"?, Palermo?, Villa General Mitre?, Villa Riachuelo?, Villa Pueyrredón?, "San Telmo, Buenos Aires"?, Villa Urquiza?, Villa Santa Rita?, Villa Ortúzar?, "Monserrat, Buenos Aires"?, "Coghlan, Buenos Aires"?, Colegiales?, Parque Chacabuco?, Mataderos?, Constitución?, "Floresta, Buenos Aires"?, Villa Crespo?, Villa Soldati?, "La Paternal, Buenos Aires"?, Liniers?, Monte Castro?, Nueva Pompeya?, San Nicolás?, "Núñez, Buenos Aires"?, Parque Chas?, Parque Patricios?, San Cristóbal?, "Almagro, Buenos Aires"?]>
#             area: #<Reality::Measure(203 km²)>
#            coord: #<Reality::Geo::Coord(34°35′58″S,58°22′54″W)>
#          country: #<Reality::Entity?(Argentina)>
#       created_at: #<Date: 1580-06-21>
#        elevation: #<Reality::Measure(25 m)>
#        long_name: "Autonomous City of Buenos Aires"
#       neighbours: #<Reality::Entity::List[Buenos Aires Province?]>
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
 => false 
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
Reality::Entity('Ruby') # => page about mineral
Reality::Entity('Ruby (programming language)') # => page about programming language
```

Further Reality versions would at least work smarter with disambiguation
pages and "other uses" link. But currently, that's just what you have.

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
# => 
```

### Lists

Let's look closer at this part:

```ruby
ar.neighbours
```

### Helper classess


### Using external services


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

**Shorcuts**: `require "reality/shortcuts"` provides you with pretty
concise syntax:

```ruby
E('Yukihiro Matsumoto')

L('Argentine', 'Bolivia', 'Chile')

continents
```

## Good. What next?..

## Want to help?

## Credits

## License
