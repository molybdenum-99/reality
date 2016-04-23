module Reality
  module IRuby
    using Refinements
    
    def IRuby.templates
      @templates ||=
        Dir[File.expand_path('../iruby/templates/*.erb', __FILE__)].
        map{|path| [File.basename(path).sub(/\..*$/, '').to_sym, ERB.new(File.read(path).strip)]}.
        to_h.derp{|h| Hashie::Mash.new(h)}
    end
  end
  
  class Measure
    def to_html
      Reality::IRuby.templates.measure.result(binding)
    end
  end

  class TZOffset
    def to_html
      Reality::IRuby.templates.tz_offset.result(binding)
    end
  end

  class Geo::Coord
    def to_html
      Reality::IRuby.templates.geo_coord.result(binding)
    end
  end
  
  class Entity
    #def to_html
      #"<span style='background-color: #FBFBC1;'>#{name}</span>"
    #end

    #STYLE = %Q{
      #<style>
        #.reality-entity {border-color: '#FFA500;'}
        #.reality-entity th {font-weight: bold; background-color: #F8F8D3;'}
      #</style>
    #}

    #def to_html
      #if loaded?
        #STYLE + 
        #"<table class='reality-entity'>" +
          #values.sort_by(&:first).map{|key, value|
            #"<tr><th>#{key}</th><td>#{value.inspect}</td></tr>"
          #}.join +
        #"</table>"
      #else
        #"<span style='background-color: #FBFBC1;'>#{name}</span>"
      #end
    #end

    def to_html
      if loaded?
        Reality::IRuby.templates.entity.result(binding)
      else
        Reality::IRuby.templates.entity_n.result(binding)
      end
    end

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
      to_a.map{|i| i.nil? ? "<span style='background-color: gray;'>nil</span>" :  "<span style='background-color: #FBFBC1;'>#{i.name}</span>"}.
        join(', ') + ']'
    end
  end
end
