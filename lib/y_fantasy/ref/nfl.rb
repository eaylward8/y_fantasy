# frozen_string_literal: true

module YFantasy
  module Ref
    module Nfl
      TEAM_KEY_MAP = {
        "nfl.t.1": {key: "nfl.t.1", abbrev: "atl", city: "Atlanta", team_name: "Falcons"},
        "nfl.t.2": {key: "nfl.t.2", abbrev: "buf", city: "Buffalo", team_name: "Bills"},
        "nfl.t.3": {key: "nfl.t.3", abbrev: "chi", city: "Chicago", team_name: "Bears"},
        "nfl.t.4": {key: "nfl.t.4", abbrev: "cin", city: "Cincinnati", team_name: "Bengals"},
        "nfl.t.5": {key: "nfl.t.5", abbrev: "cle", city: "Cleveland", team_name: "Browns"},
        "nfl.t.6": {key: "nfl.t.6", abbrev: "dal", city: "Dallas", team_name: "Cowboys"},
        "nfl.t.7": {key: "nfl.t.7", abbrev: "den", city: "Denver", team_name: "Broncos"},
        "nfl.t.8": {key: "nfl.t.8", abbrev: "det", city: "Detroit", team_name: "Lions"},
        "nfl.t.9": {key: "nfl.t.9", abbrev: "gb", city: "Green Bay", team_name: "Packers"},
        "nfl.t.10": {key: "nfl.t.10", abbrev: "ten", city: "Tennessee", team_name: "Titans"},
        "nfl.t.11": {key: "nfl.t.11", abbrev: "ind", city: "Indianapolis", team_name: "Colts"},
        "nfl.t.12": {key: "nfl.t.12", abbrev: "kc", city: "Kansas City", team_name: "Chiefs"},
        "nfl.t.13": {key: "nfl.t.13", abbrev: "lv", city: "Las Vegas", team_name: "Rakeyers"},
        "nfl.t.14": {key: "nfl.t.14", abbrev: "lar", city: "Los Angeles", team_name: "Rams"},
        "nfl.t.15": {key: "nfl.t.15", abbrev: "mia", city: "Miami", team_name: "Dolphins"},
        "nfl.t.16": {key: "nfl.t.16", abbrev: "min", city: "Minnesota", team_name: "Vikings"},
        "nfl.t.17": {key: "nfl.t.17", abbrev: "ne", city: "New England", team_name: "Patriots"},
        "nfl.t.18": {key: "nfl.t.18", abbrev: "no", city: "New Orleans", team_name: "Saints"},
        "nfl.t.19": {key: "nfl.t.19", abbrev: "nyg", city: "New York", team_name: "Giants"},
        "nfl.t.20": {key: "nfl.t.20", abbrev: "nyj", city: "New York", team_name: "Jets"},
        "nfl.t.21": {key: "nfl.t.21", abbrev: "phi", city: "Philadelphia", team_name: "Eagles"},
        "nfl.t.22": {key: "nfl.t.22", abbrev: "ari", city: "Arizona", team_name: "Cardinals"},
        "nfl.t.23": {key: "nfl.t.23", abbrev: "pit", city: "Pittsburgh", team_name: "Steelers"},
        "nfl.t.24": {key: "nfl.t.24", abbrev: "lac", city: "Los Angeles", team_name: "Chargers"},
        "nfl.t.25": {key: "nfl.t.25", abbrev: "sf", city: "San Francisco", team_name: "49ers"},
        "nfl.t.26": {key: "nfl.t.26", abbrev: "sea", city: "Seattle", team_name: "Seahawks"},
        "nfl.t.27": {key: "nfl.t.27", abbrev: "tb", city: "Tampa Bay", team_name: "Buccaneers"},
        "nfl.t.28": {key: "nfl.t.28", abbrev: "was", city: "Washington", team_name: "Commanders"},
        "nfl.t.29": {key: "nfl.t.29", abbrev: "car", city: "Carolina", team_name: "Panthers"},
        "nfl.t.30": {key: "nfl.t.30", abbrev: "jax", city: "Jacksonville", team_name: "Jaguars"},
        "nfl.t.33": {key: "nfl.t.33", abbrev: "bal", city: "Baltimore", team_name: "Ravens"},
        "nfl.t.34": {key: "nfl.t.34", abbrev: "hou", city: "Houston", team_name: "Texans"}
      }

      def team(key)
        TEAM_KEY_MAP.fetch(key.to_sym, nil)
      end
      module_function :team
    end
  end
end
