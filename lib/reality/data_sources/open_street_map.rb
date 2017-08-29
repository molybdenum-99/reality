require 'faraday'
require 'json'

module Reality
  using Refinements

  QUERY_REL = %{
    [out:json];
    rel(%{osm_id})->.main;
    (node(r.main); way(r.main););
    out tags;
    .main out;
  }.freeze

  QUERY_NODE = %{
    [out:json];
    node(%{osm_id});
    out;
  }.freeze

  module DataSources
    class OpenStreetMap
      def get(id)
        type, id = id.split(':')
        query = type == 'rel' ? QUERY_REL % {osm_id: id} : QUERY_NODE % {osm_id: id}
        faraday.get('', data: query).body
          .derp(&JSON.method(:parse))['elements']
          .derp { |els| parse_relation(els.last, els[0..-2]) }
      end

      private

      def faraday
        @faraday ||= Faraday.new('http://overpass-api.de/api/interpreter')
      end

      def parse_relation(rel, members)
        members = members
          .select { |m| m['tags']&.key?('name') }
          .map { |m| [m['id'], m] }.to_h
        {'id' => rel['id']}
          .merge(rel['tags'])
          .derp { |res|
            if label_ref = rel['members']&.detect { |m| m['role'] == 'label' }
              label = members.delete(label_ref['ref'])
              res.merge('label_id' => "node:#{label['id']}").merge(label['tags'])
            elsif admin_centre_ref = rel['members']&.detect { |m| m['role'] == 'admin_centre' }
              centre = members[admin_centre_ref['ref']]
              admin_centre = if (centre['tags']['name:en'] || centre['tags']['name']) == (rel['tags']['name:en'] || rel['tags']['name'])
                members.delete(admin_centre_ref['ref'])
              end
              if admin_centre
                res.merge('label_id' => "node:#{admin_centre['id']}").merge(admin_centre['tags'])
              else
                res
              end
            else
              res
            end
          }
          .merge(
            rel['members']&.derp { |rel_members|
              rel_members
              .group_by { |m| m['role'] }
              .map { |role, ms| [role, ms.map { |m| members[m['ref']] }.compact.derp(&method(:group_members))] }
              .reject { |role, ms| ms.empty? }
              .sort_by(&:first)
              .to_h
            } || {}
          )
          .map { |k, v| post_process(k, v) }
          .to_h
      end

      def group_members(ms)
        ms
          .map { |m| {id: "#{m['type']}:#{m['id']}", name: (m['tags']['name:en'] || m['tags']['name'])} }
          .group_by { |m| m[:name] }
          .map { |name, ms|
            if ms.count <= 5
              "#<Link[#{ms.map{|m| m[:id]}.join(',')}] #{name}>"
            else
              "#<Link[#{ms.map{|m| m[:id]}.first(5).join(',')}...#{ms.count - 5} more...] #{name}>"
            end
          }
      end

      def post_process(key, value)
        value = case key
        when 'population'
          Measure['person'].new(value.to_i)
        when 'sqkm'
          Measure['km²'].new(value.to_f)
        else
          value
        end
        [key, value]
      end
    end
  end
end
