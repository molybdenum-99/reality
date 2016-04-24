require 'erb'

module Reality
  module IRuby
    using Refinements
    
    def IRuby.templates
      @templates ||=
        Dir[File.expand_path('../iruby/templates/*.erb', __FILE__)].
        map{|path| [File.basename(path).sub(/\..*$/, '').to_sym, ERB.new(File.read(path).strip)]}.
        to_h.derp{|h| Hashie::Mash.new(h)}
    end

    module Extensions
      def html_safe_inspect
        inspect.gsub('<', '&lt;')
      end

      def html_reality_style
        'border: 1px solid #B0C6D0; background-color: #DEE7EC; padding: 1px; cursor: pointer;'
      end
    end
  end
  
  class Measure
    def to_html
      Reality::IRuby.templates.measure.result(binding)
    end

    include Reality::IRuby::Extensions
  end

  class TZOffset
    def to_html
      Reality::IRuby.templates.tz_offset.result(binding)
    end

    include Reality::IRuby::Extensions
  end

  class Geo::Coord
    def to_html
      Reality::IRuby.templates.geo_coord.result(binding)
    end

    include Reality::IRuby::Extensions
  end
  
  class Entity
    def to_html
      if loaded?
        Reality::IRuby.templates.entity.result(binding)
      else
        compact_to_html
      end
    end

    def compact_to_html
      Reality::IRuby.templates.entity_n.result(binding)
    end

    include Reality::IRuby::Extensions

    def path
      '(somehow iruby notebook fails without this thing)'
    end

    private

    def iruby_render(value)
      case value
      when ->(v){v.respond_to?(:to_html)}
        value.to_html
      else
        value.to_s.gsub('<', '&lt;')
      end
    end
  end

  class Comparator
    attr_reader :entities
    
    def initialize(entities)
      @entities = entities
    end

    include Reality::IRuby::Extensions

    def keys
      entities.map{|e| e.values.keys}.flatten.uniq.sort
    end

    def to_html
      Reality::IRuby.templates.compare.result(binding)
    end
  end

  class List
    def to_html
      '[' + 
      to_a.map{|i| i.nil? ? "<span style='background-color: gray;'>nil</span>" : i.compact_to_html}.
        join(', ') + ']'
    end

    def to_dataframe(*fields)
      require 'daru'
      
      load! unless any?(&:loaded?)
      
      if fields.empty?
        fields = map{|e| e.values.keys}.flatten.uniq.sort
      end
      Daru::DataFrame.new(
        fields.map{|f| [f, map{|e| Entity::Coercion.to_df_type(e.send(f))}]}.to_h,
        index: map(&:name)
      )
    end

    def compare
      load! unless any?(&:loaded?)
      Comparator.new(to_a.compact)
    end
  end
end
