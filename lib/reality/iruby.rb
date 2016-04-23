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
        Reality::IRuby.templates.entity_n.result(binding)
      end
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

  class List
    def to_html
      '[' + 
      to_a.map{|i| i.nil? ? "<span style='background-color: gray;'>nil</span>" : i.to_html}.
        join(', ') + ']'
    end
  end
end
