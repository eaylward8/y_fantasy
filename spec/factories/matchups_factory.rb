# frozen_string_literal: true

FactoryBot.define do
  factory :matchup, class: "YFantasy::Matchup" do
    is_consolation { false }
    is_playoffs { false }
    status { "postevent" }
    week { 1 }
    week_end { "2024-09-09" }
    week_start { "2024-09-05" }
    teams { [] }

    factory :matchup_with_teams do
      teams do
        [
          YFantasy::Team.new(**attributes_for(:team, team_key: "123.l.456789.t.1"), name: "Team 1"),
          YFantasy::Team.new(**attributes_for(:team, team_key: "123.l.456789.t.2"), name: "Team 2")
        ]
      end

      trait :with_winner do
        winner_team_key { teams.sample.team_key }
      end
    end
  end
end
