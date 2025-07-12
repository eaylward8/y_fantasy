# frozen_string_literal: true

FactoryBot.define do
  factory :league, class: "YFantasy::League" do
    league_key { "123.l.456789" }
    league_id { "456789" }
    allow_add_to_dl_extra_pos { 0 }
    draft_status { "postdraft" }
    edit_key { 1 }
    end_date { "2024-12-30" }
    felo_tier { "silver" }
    game_code { "nfl" }
    is_cash_league { 0 }
    is_pro_league { 0 }
    league_type { "private" }
    league_update_timestamp { 1736408692 }
    logo_url { "https://fakeyahoourl.com" }
    name { "NFL League" }
    num_teams { 12 }
    renew { "111_111111" }
    renewed { "222_222222" }
    scoring_type { "head" }
    season { 2024 }
    start_date { "2024-09-05" }
    url { "https://fakeyahoourl.com" }
    weekly_deadline { nil }
  end
end
