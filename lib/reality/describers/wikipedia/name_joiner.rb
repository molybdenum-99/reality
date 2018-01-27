module Reality
  module Describers
    class Wikipedia
      module NameJoiner
        module_function

        CONVOLUTIONS = [
          [/^blank(?<number>\d+)?_name(?<section>_sec\d+)?$/, 'blank%{number}_info%{section}'],
          [/^(?<name>\D+)_type(?<number>\d+)?$/, '%{name}_name%{number}'],
          [/^(?<name>\D+)_title(?<number>\d+)?$/, '%{name}_name%{number}'],
          [/^(?<prefix>\D+)(?<number1>\d+)?_title(?<number2>\d+)?$/, '%{prefix}%{number1}_info%{number2}'],
          [/^(?<prefix>\D+)_blank(?<number>\d+)?_title$/, '%{prefix}_blank%{number}'],
          [/^(?<prefix>\D+)_blank(?<number>\d+)?_title$/, '%{prefix}_blank%{number}_km2'],
          [/^(?<name>\D+)_type(?<number>\d+)?$/, '%{name}%{number}'],
          # Provides too uniq "variables", like "Unification of Buda, Pest and Óbuda": #<Reality::Date 1873-11-17>
          # better have something like established: <event: foo @ time: bar>
          # [/^(?<name>\D+)_title(?<number>\d+)?$/, '%{name}_date%{number}'],
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
