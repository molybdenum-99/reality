
module Reality
  module Describers
    class Wikidata
      # FIXME: All of it is as ad-hoc as possible.
      # Should be reconsidered from the standpoints:
      # * permanent cache of ALL wikidata units and their corresponded "parsings"; probably with using
      #   ad-hoc scripts + curated editing; but Wikidata also provides helpful data sometimes, like
      #   "SI equivalent" and stuff
      # * moving the functionality to Reality::Measure?
      module Units
        module_function

        SYNONYMS = {
          metre: 'm',
          meter: 'm'
        }.transform_keys(&:to_s).freeze

        def parse(str)
          SYNONYMS.fetch(str, str)
        end
      end
    end
  end
end
