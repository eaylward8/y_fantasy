# frozen_string_literal: true

require "thor"

module YFantasy
  class CLI < Thor
    include Thor::Actions

    desc "version", "Prints the YFantasy gem version"
    def version
      puts YFantasy::VERSION
    end

    desc "nfl_teams", "Prints Yahoo NFL team information"
    def nfl_teams
      require "y_fantasy/ref/nfl"

      YFantasy::Ref::Nfl::TEAM_KEY_MAP.each_with_index do |(key, team), idx|
        if idx.zero?
          puts format("%-15s %-15s %-10s %-10s", "City", "Team Name", "Abbrev", "Yahoo Key")
          puts "-" * 55
        end
        puts format("%-15s %-15s %-10s %-10s", team[:city], team[:team_name], team[:abbrev], key)
      end
    end

    desc "help", "Prints this help message"
    def help
      puts self.class.help
    end

    no_commands do
      def self.help
        <<~HELP
          Usage: y_fantasy [command] [options]

          Commands:
            version   - Prints the YFantasy gem version
            nfl_teams - Prints Yahoo NFL team information
            help      - Prints this help message
        HELP
      end
    end
  end
end
