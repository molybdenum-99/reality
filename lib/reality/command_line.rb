module Reality
  class CommandLine
    attr_accessor :search_term, :article, :commands, :errors

    def initialize(article, commands = [])
      self.search_term = "#{article}"
      self.article = Reality::Entity(search_term)
      self.errors  = []

      if commands.count > 0
        self.commands = commands.map(&:to_sym)
      else
        self.commands = [:describe]
      end
    end

    def self.display_usage
      puts "usage: really \"[search-string]\" [entity-command] [chained-command(s) ...]"
    end

    def article_found?
      !self.article.nil?
    end

    def subcommand_for(object, subcommand)
      if object.respond_to?(subcommand.to_sym)
        object.send(subcommand.to_sym)
      else
        self.errors << "#{object} doesn't respond to #{subcommand}"
        nil
      end
    end

    def results!
      return "Nothing found for: #{self.search_term}" unless self.article_found?
      puts "Attempting entity chain: #{self.commands}" if ENV['DEBUG']

      result = self.article.send(self.commands.shift)

      while subcommand = self.commands.shift
        puts "Calling #{self.article.class}##{subcommand}" if ENV['DEBUG']
        result = subcommand_for(result, subcommand)
      end

      if errors.any?
        "Error: #{ errors.join("\n") }"
      else
        result
      end
    end
  end
end
