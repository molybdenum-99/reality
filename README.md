Reality
=======

[![Gem Version](https://badge.fury.io/rb/reality.svg)](http://badge.fury.io/rb/reality)
[![Join the chat at https://gitter.im/molybdenum-99/reality](https://badges.gitter.im/molybdenum-99/reality.svg)](https://gitter.im/molybdenum-99/reality?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**Reality** is your quick access point to almost any entity existing in
real world (and described in Wikipedia). Its goal is to make the world
inspectable and computable.

## Table Of Contents

* [Showcase](#showcase)
* [Is it real? Is it really working?.. But how?](#is-it-real-is-it-really-working-but-how)
* [Why/when do I need this?..](#whywhen-do-i-need-this)
* [Uhm, ok. How to use it?](#uhm-ok-how-to-use-it)
  * [...from your code](#from-your-code)
  * [...from command-line](#from-command-line)
  * [...from interactive console](#from-interactive-console)
* [Good. What next?..](#good-what-next)
* [Want to help?](#want-to-help)
* [Compatibility](#compatibility)
* [Credits](#credits)
* [License](#license)

## Showcase

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
t2 = Entity('Terminator 2')
t2.actors.each do |actor|
  puts "#{ actor.name }: #{ actor.age_at(t2.published_at) }"
end
# Edward Furlong: 13
# Arnold Schwarzenegger: 43
# Linda Hamilton: 34
# Robert Patrick: 32
```

## Is it real? Is it really working?.. But how?

Yes. Every example you can see above is working. And many other things
are working. And almost _any_ thing which Wikipedia knows about, can be
loaded through **Reality**, and somehow inspected and used and navigated
to next entities and measured and ...

Read more at ["How it works"]() page in our wiki. It's complicated, yet
quite interesting.

## Why/when do I need this?..

* Demos and experiments;
* Enrichement of existing data;
* Teaching Ruby and data processing on realistic data...

...and [more](applications).

## Uhm, ok. How to use it?

First, install the gem as usual (it is on rubygems, and named "reality"),
using Gemfile/`bundle install` or `gem install reality`.

Now, you can use it...

### ...from your code

```ruby
require 'reality'

th = Reality::Entity('Thailand')
p th.area / th.population

list = Reality::List('Terminator', 'Terminator 2', 'Terminator 3', 'Terminator 4', 'Terminator 5')
list.load!

p list.map(&:published_at)

```

Read more at [Tutorial]() and [Examples]() in our wiki.

### ...from command-line

The `reality` command allows you to investigate various
concepts in your terminal:

```
$ reality Katmandu
----------------------------------
#<Reality::Entity(Kathmandu):city>
----------------------------------
             area: #<Reality::Measure(49 km²)>
            coord: #<Reality::Geo::Coord(27°43′0″N,85°22′0″E)>
          country: #<Reality::Entity?(Nepal)>
        elevation: #<Reality::Measure(1,400 m)>
       located_in: #<Reality::Entity?(Nepal)>
        long_name: "Kathmandu Metropolitan City\nKTM"
 official_website: "http://www.kathmandu.gov.np"
       population: #<Reality::Measure(975,453 person)>
        tz_offset: #<Reality::TZOffset(UTC+05:45)>


$ reality Beatles albums first
Please Please Me
```

See [wikipage](Command-line usage) for details.

### ...from interactive console

The `reality -i` command opens interactive console, allowing you to
investigate Reality's features immediately. It also provides many useful
shortcuts for less typing:

```
$ reality -i

reality#1:001:0> b = E('Brno')
# => #<Reality::Entity(Brno):city>
reality#1:002:0> b.area
# => #<Reality::Measure(230 km²)>
reality#1:003:0> b.coord.weather
# => #<Reality::Weather(10°C, Rain)>
```

...and so on. Read more at [Interactive console]() and feel free to
experiment!

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

[Development]() page in wiki explains some things a bit deeper.

## Compatibility

Ruby 2+ is a must (we love refinements, keywords arguments and other
cool stuff). JRuby & Rubinius compatibility was not checked still, help
would be appreciated here!

Note that there could be a problem with SSL sertificates while connecting
to Wikipedia API. _TODO: explain the problem and point to recipes._
  
## Credits

* [Victor Shepelev](https://zverok.github.io) [@zverok](https://github.com/zverok);
* Sergey Mostovoy [@smostovoy](https://github.com/smostovoy);
* [Valentino Stoll](http://www.awesomevibe.com/) [@codenamev](https://github.com/codenamev);
* [Several great contributors](https://github.com/molybdenum-99/reality/graphs/contributors).

Development of first version was sponsored by
[2015 Ruby Association Grant](http://www.ruby.or.jp/en/news/20151116.html).

Initial idea is inspired by "integrated data" of
[Wolfram Language](http://reference.wolfram.com/language/).

## License

[MIT](https://github.com/molybdenum-99/reality/blob/master/LICENSE.txt)
