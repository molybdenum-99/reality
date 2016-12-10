require_relative 'base'

module Reality
  module DataSources
    using Reality::Refinements

    class Wikipedia < Base
      register :wikipedia

      class << self
        def infobox(var, name, &block)
          rule(name) { |page| block.call(page.infobox.fetch(var).first) }
        end
      end

      def get(title)
        Infoboxer.wikipedia.get(title, prop: :wbentityusage).derp(&method(:page_to_hash))
      end

      private

      def page_to_hash(page)
        {
          title: page.title,
          wikidata_id: page.source.wbentityusage.keys.grep(/^Q/).first
        }.merge(self.class.rules.map { |name, block| [name, block.call(page)] }.to_h.compact)
      end
    end
  end
end
