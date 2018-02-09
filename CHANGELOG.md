# Reality chaotich changelog

## 0.1.0.pre - 2018-02-09

Pre-release of completely rewritten version. Still a long way to go before proper release, it will be
described here properly at its time.

## 0.0.4 - 2016-04-18

* Economic indicators from Quandl;
* Fallback to search in Wikidata only, if there is no Wikipedia page;
* Add `reality` binary for using from command line;
* Several small and not-so-small refactorings (especially of Wikidata
  module, which was a complete mess);
* Add `Entity#to_h` (with only core types, so entities are JSON-able now!);
* Enchance of `Geo::Coord` class with several new features;
* Allow sparse `Reality::List`, with `nil`s alongside with entities,
  useful for things like `cities_list.map(&:head_of_government).load!` --
  not for all cities head of government is known, but the code will work
  nevertheless;
* More useful Wikidata predicates;
* Optional `Reality::Names` module, allowing code like `Argentina.capital`;
* Some docs -- both YARD and Wiki.

## 0.0.3 - 2016-03-02

First really public release
