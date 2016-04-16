module Reality
  class Entity
    #def to_html
      #"<span style='background-color: #FBFBC1;'>#{name}</span>"
    #end

    STYLE = %Q{
      <style>
        .reality-entity {border-color: '#FFA500;'}
        .reality-entity th {font-weight: bold; background-color: #F8F8D3;'}
      </style>
    }

    def to_html
      if loaded?
        STYLE + 
        "<table class='reality-entity'>" +
          values.sort_by(&:first).map{|key, value|
            "<tr><th>#{key}</th><td>#{value.inspect}</td></tr>"
          }.join +
        "</table>"
      else
        "<span style='background-color: #FBFBC1;'>#{name}</span>"
      end
    end

    def path
      '(somehow iruby notebook fails without this thing)'
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
