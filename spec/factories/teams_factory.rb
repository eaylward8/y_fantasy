# frozen_string_literal: true

FactoryBot.define do
  factory :team, class: "YFantasy::Team" do
    team_key { "123.l.456789.t.1" }
    team_id { team_key.slice(-1) }
    has_draft_grade { true }
    league_scoring_type { "head" }
    managers { [] }
    name { "I'm Randy Butternubs" }
    number_of_moves { 2 }
    number_of_trades { 0 }
    roster_adds { {} }
    team_logos { {} }
    url { "https://fakeyahoourl.com" }
  end
end
