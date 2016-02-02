require 'naught'
require 'addressable/uri'

module Nokogiri
    module More
        module NodeOnlyFor
            def only_for!(selector)
                matches?(selector) or fail(ArgumentError, "Doesn't works for nodes other than '#{selector}'")
            end
        end
        
        module NodeHref
            include NodeOnlyFor
            
            def href
                #only_for!('a[href]')
                document.absolute(self['href'])
            end
        end
        
        module DocumentURI
            def uri
                url ? Addressable::URI.parse(url) : nil
            end
            
            def absolute(link)  
                if uri
                    (uri + link).to_s
                else
                    Addressable::URI.parse(link).to_s # double check it's really a link
                end
            end
        end
        
        module NodeChildrenGroups
            def children_groups(*selectors)
                groups = []
                flat = children.select{|node| selectors.any?{|s| node.matches?(s)}}
                while !flat.empty?
                    groups << make_group(flat, selectors)
                end
                groups
            end
            
            include NodeOnlyFor
            
            def each_term
                only_for!('dl')
                children_groups('dt', 'dd')
            end
            
            private
            
            def make_group(flat, selectors)
                sel = selectors.dup
                group = [[]]
                while !flat.empty?
                    if flat.first.matches?(sel.first)
                        group.last << flat.shift
                    elsif sel.size > 1 && flat.first.matches?(sel[1])
                        sel.shift
                        group << []
                        group.last << flat.shift
                    else
                        break
                    end
                end
                group
            end
        end
        
        module NodeText
            def text_
                text.strip 
            end
        end
        
        NodeNaught = Naught.build do |config|
            config.black_hole
            
            def tap # so you can just at?(selector).tap{|node| - and never be here, if it's not found
                self
            end
        end
        
        class NodeNotFound < RuntimeError
        end
        
        module NodeBangMethods
            def at!(selector)
                bang!(at(selector), selector)
            end
            
            def at_css!(selector)
                bang!(at_css(selector), selector)
            end

            def at_xpath!(selector)
                bang!(at_xpath(selector), selector)
            end
            
            def find_child!(selector)
                bang!(find_child(selector), selector)
            end
            
            private
            
            def bang!(node, selector)
                if node
                    node
                else
                    no_node!(selector)
                end
            end
            
            def no_node!(selector)
                #case Nokogiri::More::Config.bang_mode
                #when :fail
                    fail NodeNotFound, "#{name} have no node at #{selector}"
                #when :naught
                    #NodeNaught.new
                #when :log
                    #NodeNaught.new
                #end
            end
        end
        
        module NodeQuestMethods
            def at?(selector)
                at(selector) || NodeNaught.new
            end

            def at_css?(selector)
                at_css(selector) || NodeNaught.new
            end

            def at_xpath?(selector)
                at_xpath(selector) || NodeNaught.new
            end
            
            def find_child?(selector)
                find_child(selector) || NodeNaught.new
            end
        end
        
        module NodeFindChildren
            def find_child(selector)
                children.filter(selector).first
            end

            def find_children(selector)
                children.filter(selector)
            end
        end
    end
    
    # now let's do evil
    class ::Class
        public :include
    end
    
    Nokogiri::XML::Document.include More::DocumentURI
    Nokogiri::XML::Node.include More::NodeText
    Nokogiri::XML::Node.include More::NodeHref
    Nokogiri::XML::Node.include More::NodeChildrenGroups
    
    Nokogiri::XML::Node.include More::NodeBangMethods
    Nokogiri::XML::Node.include More::NodeQuestMethods
    Nokogiri::XML::Node.include More::NodeFindChildren

    Nokogiri::XML::NodeSet.include More::NodeBangMethods
    Nokogiri::XML::NodeSet.include More::NodeQuestMethods
    Nokogiri::XML::NodeSet.include More::NodeFindChildren
end

