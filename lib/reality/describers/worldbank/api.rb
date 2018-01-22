require 'tlaw'

class Reality::DataSources::Worldbank
  class API < TLAW::API
    define do
      base 'http://api.worldbank.org'

      post_process_replace { |response|
        if response.is_a?(Array) && response.size == 1 && response.first.is_a?(Hash)
          response.first
        elsif response.is_a?(Array) && response.size == 2
          {'meta' => response.first, 'data' => response.last}
        else
          response
        end
      }

      post_process_items('data') do
        post_process 'longitude', &:to_f
        post_process 'latitude', &:to_f
        post_process 'value', &:to_f
        # post_process 'date', &Date.method(:parse)
      end

      SINGULAR = ->(h) { h['data'].first }

      namespace :countries, '/countries' do
        endpoint :list, '?format=json' do
          param :income_level, field: :incomeLevel
          param :lending_type, field: :lendingType
        end

        namespace :[], '/{country}' do
          #param :countries, :to_a, format: ->(c) { c.join(';') }
          # TODO: splat

          endpoint :get, '?format=json' do
            #post_process_replace(&SINGULAR)
          end

          endpoint :indicator, '/indicators/{name}?format=json'
          # TODO: filter indicator by date
        end
      end

      namespace :dictionaries, '' do
        endpoint :topics, '/topics?format=json'
        #namespace :sources, '/sources?format=json' do

        endpoint :income_levels, '/incomeLevels?format=json'
        endpoint :lending_types, '/lendingTypes?format=json'

        namespace :indicators do
          endpoint :list, '?format=json'
          endpoint :by_topic, '/../topic/{topic_id}/indicator?format=json'
          endpoint :by_source, '/../source/{source_id}/indicators?format=json'

          endpoint :[], '/{name}?format=json' do
            post_process_replace(&SINGULAR)
          end
        end
      end
    end
  end
end
