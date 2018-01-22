module Reality
  using Refinements

  module Describers
    class Wikipedia
      module NameJoiner
        module_function

        CONVOLUTIONS = [
          [/^blank(?<number>\d+)?_name(?<section>_sec\d+)?$/, 'blank%{number}_info%{section}'],
          [/^(?<name>.+)_type(?<number>\d+)?$/, '%{name}_name%{number}'],
          [/^(?<name>.+)_title(?<number>\d+)?$/, '%{name}_name%{number}'],
          [/^(?<name>.+)_title(?<number>\d+)?$/, '%{name}_date%{number}'],
          [/^(?<prefix>.+)_blank(?<number>\d+)?_title$/, '%{prefix}_blank%{number}'],
          [/^(?<name>.+)_type(?<number>\d+)?$/, '%{name}%{number}'],
        ]

        def call(vars)
          vars.map { |var| [var.label, var] }
            .yield_self(&method(:join_names))
        end

        def join_names(pairs)
          remove = []
          replace = {}
          pairs.each_with_index do |(name, value), i|
            CONVOLUTIONS
              .select { |name_pat, val_pat| name.match(name_pat) }
              .each do |name_pat, val_pat|
                match = name.match(name_pat).to_h
                val_name = val_pat % match
                val_candidates = pairs.select { |name, _| name == val_name }
                next if val_candidates.empty?
                result_name = [match[:prefix], value.to_s].compact.join('_')
                # log.debug "Convolving #{name} with #{val_name} to #{result_name} (#{val_candidates.count} values)"

                remove << val_name
                replace[name] = val_candidates.map { |_, val| [result_name, val] }
                break
              end
          end
          pairs.map { |name, value|
            if remove.include?(name)
              []
            elsif replace.key?(name)
              replace[name]
            else
              [[name, value]]
            end
          }.flatten(1)
        end
      end
    end
  end
end
