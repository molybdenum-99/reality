Reality
=======

**Reality** is a gem (in its early development stage) for easy and
convenient recieving data on various real-life knowledge entities. It
uses open data sources (only Wikipedia and DBPedia currently, but more
of them planned) and makes data accessible to novices, experimentators
and hobbyists.

Now, at earliest version possible, Reality provides access only to
world countries data:

```ruby
# One country
ar = Reality.country('Argentina')
ar.area # => Reality::Measure(km²)
ar.capital # => Buenos Aires
ar.leaders[:president] # => Mauricio Macri

# List of countries:
countries = Reality.countries

countries.
  select{|c| c.continent == 'Africa'}.
  reject{|c| (c.gdp / c.population).amount > 10_000}.
  map(:population).inject(:+)
# => Reality::Measure( people)
```

Rough examples of what the library is supposed to do eventually, can be
seen at [showcase draft](https://github.com/molybdenum-99/reality/wiki).

Roadmap
-------

* [x] World countries: first example of Wikipedia -> easy data
  translation;
* [x] Generic named measure concept and arithmetics;
* [ ] Usage of DBPedia as a query engine (like "countries with
  population larger than" and so on);
* [ ] More of related entities, starting from `city`, and interaction
  with countries (like "cities of this country" and more);
* [ ] Generic entity concept;
* [ ] Wrappers for most common and most interesting data types (like
  people, famous places, music bands, movies, and so on) from Wikipedia;
* [ ] Extending Reality sources to other open data sources, like
  OpenStreetMap, OpenWeatherMap, OpenExchange and so on;
* [ ] Extending Reality calculations to real world time and space, like
  "calculate sunset at concrete date for concrete city and convert it
  to my timezone", or "calculate distance between those two places" and
  so on;
* [ ] Integration with means of pretty output (like RMagick and IRuby
  Notebooks);
* ....

Authors
-------

* [Victor Shepelev](https://zverok.github.io)

Development sponsored by
[2015 Ruby Association Grant](http://www.ruby.or.jp/en/news/20151116.html).

Initial idea is inspired by "integrated data" of
[Wolfram Language](http://reference.wolfram.com/language/).

License
-------

MIT
