# frozen_string_literal: true

RSpec.describe "Requesting Games" do
  subject { YFantasy::Game }

  before do
    allow(YFantasy::Api::Authentication).to receive(:authenticate).and_return(true)
    allow(YFantasy::Api::Authentication).to receive(:access_token).and_return("fake_access_token")
    allow(YFantasy::Api::Authentication).to receive(:refresh_token).and_return("fake_refresh_token")
  end

  describe "requesting a single game" do
    before do
      stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl")
        .to_return(status: 200, body: Fixture.load("resources/raw/game_nfl.xml"))
    end

    it "returns a Game instance" do
      game = subject.find(:nfl)
      expect(game).to be_instance_of(subject)
      expect(game.code).to eq("nfl")
    end
  end

  describe "requesting a single game with one subresource" do
    before do
      stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl/game_weeks")
        .to_return(status: 200, body: Fixture.load("resources/raw/game_nfl_game_weeks.xml"))
    end

    it "returns a Game instance with the requested subresources" do
      game = subject.find(:nfl, with: :game_weeks)
      expect(game).to be_instance_of(subject)
      expect(game.game_weeks).to all(be_a(YFantasy::Game::GameWeek))
    end
  end

  describe "requesting a single game with multiple subresources" do
    before do
      stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl;out=game_weeks,roster_positions")
        .to_return(status: 200, body: Fixture.load("resources/raw/game_nfl_game_weeks_roster_positions.xml"))
    end

    it "returns a Game instance with the requested subresources" do
      game = subject.find(:nfl, with: %i[game_weeks roster_positions])
      expect(game).to be_instance_of(subject)
      expect(game.game_weeks).to all(be_a(YFantasy::Game::GameWeek))
      expect(game.roster_positions).to all(be_a(YFantasy::RosterPosition))
    end
  end

  describe "requesting a single game with nested subresources (must use find_all and scope to user)" do
    before do
      stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games;game_keys=nfl/leagues/teams")
        .to_return(status: 200, body: Fixture.load("resources/raw/game_nfl_leagues_teams_scope_to_user.xml"))
    end

    it "returns a Game instance with the requested subresources" do
      games = subject.find_all(:nfl, with: {leagues: :teams}, scope_to_user: true)
      game = games.first
      expect(game).to be_instance_of(subject)
      expect(game.leagues).to all(be_a(YFantasy::League))
      expect(game.leagues.size).to eq(2)

      league = game.leagues.first
      expect(league.teams).to all(be_a(YFantasy::Team))
      expect(league.teams.size).to eq(1)
    end
  end

  describe "requesting multiple games with leagues (must use scope to user)" do
    before do
      stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games;game_keys=nfl,nba/leagues")
        .to_return(status: 200, body: Fixture.load("resources/raw/games_nfl_nba_leagues_scope_to_user.xml"))
    end

    it "returns an array of Games" do
      games = subject.find_all(%i[nfl nba], with: :leagues, scope_to_user: true)
      expect(games).to be_instance_of(Array)
      expect(games).to all(be_a(YFantasy::Game))

      nfl_game = games.first
      expect(nfl_game.leagues).to all(be_a(YFantasy::League))

      nba_game = games.last
      expect(nba_game.leagues).to be_nil # No leagues for this game for this user
    end
  end



      # context "with subresources" do
      #   before do
      #     stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/games;game_keys=nfl,nba/roster_positions")
      #       .to_return(status: 200, body: Fixture.load("resources/raw/games_nfl_nba_roster_positions.xml"))
      #   end

      #   it "parses xml and returns a hash" do
      #     actual = client.get("games", keys: %w[nfl nba], subresources: [:roster_positions])
      #     expected = Fixture.load_yaml("resources/parsed/games_nfl_nba_roster_positions.yaml")
      #     expect(actual).to eq(expected)
      #   end
      # end
end
