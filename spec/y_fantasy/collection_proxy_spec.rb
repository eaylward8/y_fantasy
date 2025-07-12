# frozen_string_literal: true

RSpec.describe YFantasy::CollectionProxy do
  describe "#find_all" do
    let(:c_proxy) { described_class.new("games") }

    it "sets @keys ivar" do
      expect(c_proxy.instance_variable_get(:@keys)).to eq([])
      c_proxy.find_all(["games"])
      expect(c_proxy.instance_variable_get(:@keys)).to eq(["games"])
    end

    it "wraps the keys in an Array if one is not passed" do
      expect(c_proxy.instance_variable_get(:@keys)).to eq([])
      c_proxy.find_all("games")
      expect(c_proxy.instance_variable_get(:@keys)).to eq(["games"])
    end

    it "returns self" do
      expect(c_proxy.find_all(["games"])).to eq(c_proxy)
    end
  end

  describe "#with" do
    let(:c_proxy) { described_class.new("games") }

    it "adds subresources to the subresources array" do
      expect(c_proxy.instance_variable_get(:@subresources)).to eq([])
      c_proxy.with(:game_weeks)
      expect(c_proxy.instance_variable_get(:@subresources)).to eq([:game_weeks])
    end

    it "returns self" do
      expect(c_proxy.with("games")).to eq(c_proxy)
    end
  end

  describe "#for_current_user" do
    let(:c_proxy) { described_class.new("leagues") }

    it "sets @scope_to_user ivar to true" do
      expect(c_proxy.instance_variable_get(:@scope_to_user)).to be(false)
      c_proxy.for_current_user
      expect(c_proxy.instance_variable_get(:@scope_to_user)).to be(true)
    end

    it "returns self" do
      expect(c_proxy.for_current_user).to eq(c_proxy)
    end
  end

  describe "#load" do
    let(:collection) { "games" }
    let(:keys) { [:nfl, :nba] }
    let(:c_proxy) { described_class.new(collection, keys).with(:game_weeks) }
    let(:fake_client) { instance_double(YFantasy::Api::Client) }
    let(:fake_mapper) { instance_double(YFantasy::Transformations::CollectionMapper) }

    before do
      allow(c_proxy).to receive(:client).and_return(fake_client)
      allow(fake_mapper).to receive(:call)
    end

    it "makes API call and relies on CollectionMapper to transform data" do
      expect(c_proxy).to receive(:collection).and_call_original
      expect(YFantasy::Transformations::CollectionMapper).to(
        receive(:new).with(collection, subresources: [:game_weeks]).and_return(fake_mapper)
      )
      expect(fake_client).to receive(:get).with(collection, keys, [:game_weeks], scope_to_user: false)

      c_proxy.load
    end

    it "raises if collection_name is nil" do
      expect { described_class.new(nil).load }.to raise_error("No collection name provided")
    end

    it "raises if collection_name is empty string" do
      expect { described_class.new("").load }.to raise_error("No collection name provided")
    end

    it "raises if keys array is empty" do
      expect { described_class.new("games", []).load }.to raise_error("No keys provided for games collection")
    end
  end

  it "responds to Array methods" do
    expect(described_class.new("games", ["nba"])).to respond_to(:each)
  end
end
