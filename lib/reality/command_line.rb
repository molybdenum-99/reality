require 'optparse'
require 'reality/pretty_inspect'

module Reality
  class CommandLine
    attr_accessor :search_term, :article, :commands, :options, :errors

    def initialize
      parse_arguments
    end

    def self.display_usage
      puts "usage: reality \"[search-string]\" [entity-command] [chained-command(s) ...]"
    end

    def interactive?
      !!self.options[:interactive]
    end

    def article_found?
      !self.article.nil?
    end

    def subcommand_for(object, subcommand)
      if object.respond_to?(subcommand.to_sym)
        puts "Calling #{subcommand} on #{object.inspect}" if ENV['DEBUG']
        object.send(subcommand.to_sym)
      else
        self.errors << "#{object} doesn't respond to #{subcommand}"
        nil
      end
    end

    def results
      return "Nothing found for: #{self.search_term}" unless self.article_found?
      puts "Attempting entity chain: #{self.commands} on #{self.article.inspect}" if ENV['DEBUG']

      result = subcommand_for(self.article, self.commands.shift)

      while subcommand = self.commands.shift
        result = subcommand_for(result, subcommand)
      end

      if self.errors.any?
        "Error: #{ self.errors.join("\n") }"
      else
        result
      end
    end

    def run_interactive_shell
      require 'irb'
      require 'reality/shortcuts'
      ::ARGV.clear
      IRB::ExtendCommandBundle.include(Reality::Methods)
      IRB.setup nil

      IRB.conf[:IRB_NAME] = 'reality'

      IRB.conf[:PROMPT] = {}
      IRB.conf[:PROMPT][:REALITY] = {
        :PROMPT_I => '%N:%03n:%i> ',
        :PROMPT_S => '%N:%03n:%i%l ',
        :PROMPT_C => '%N:%03n:%i* ',
        :RETURN => "# => %s\n"
      }
      IRB.conf[:PROMPT_MODE] = :REALITY
      IRB.conf[:RC] = false

      IRB.conf[:MAIN_CONTEXT] = IRB::Irb.new.context

      require 'irb/ext/multi-irb'
      IRB.irb nil, self
    end

    private

    def parse_options
      self.options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: reality [options] [search-string] [entity-command] [chained-command(s) ...]"

        opts.on_tail("-i", "--interactive", "Run an interactive IRB session with Reality pre-configured for querying.") do
          self.options[:interactive] = true
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end.parse!
    end

    def parse_arguments
      parse_options
      self.search_term = "#{::ARGV.shift}"

      if self.options[:interactive]
        Reality.configure :demo
      elsif self.search_term.length > 0
        self.article = Reality::Entity(self.search_term)
        self.errors  = []

        if ::ARGV.count > 0
          self.commands = ::ARGV.map(&:to_sym)
        else
          self.commands = [:describe]
        end

        Reality.configure :demo
      else
        self.class.display_usage
        exit
      end
    end
  end
end
