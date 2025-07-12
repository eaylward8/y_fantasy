# frozen_string_literal: true

RSpec.describe YFantasy::BaseResource do
  let(:test_class) do
    Class.new(described_class)
  end

  before do
    stub_const("YFantasy::Thing", test_class)
  end

  describe "class methods" do
    describe ".for_current_user" do
      it "instantiates a CollectionProxy with scope_to_user set to true" do
        expect(YFantasy::CollectionProxy).to receive(:new).with(:things, scope_to_user: true)
        YFantasy::Thing.for_current_user
      end
    end

    describe ".find_all" do
      it "instantiates a CollectionProxy with keys" do
        keys = %w[thingamajig whatchamacallit]
        expect(YFantasy::CollectionProxy).to receive(:new).with(:things, keys)
        YFantasy::Thing.find_all(keys)
      end
    end

    describe ".find" do
      let(:key) { "thingamajig" }
      let(:thing_transformer) { ->(data) { data } }

      it "calls the API and finds a transformer to map the data" do
        expect(YFantasy::Api::Client).to receive(:get).with(:thing, key, [], week: nil)
        expect(YFantasy::Transformations).to receive(:transformer_for).with(:thing).and_return(thing_transformer)
        expect(thing_transformer).to receive(:call)

        YFantasy::Thing.find(key)
      end
    end

    describe ".fetch_subresource" do
      let(:key) { "doodad" }
      let(:thing) { instance_double(YFantasy::Thing) }

      it "makes a request for subresource data and calls the subresource method" do
        expect(YFantasy::Thing).to receive(:find).with(key, with: [:subresource]).and_return(thing)
        expect(thing).to receive(:send).with(:subresource)

        YFantasy::Thing.fetch_subresource(key, :subresource)
      end
    end

    describe ".resource_name" do
      it "returns nil for BaseResource" do
        expect(described_class.resource_name).to be_nil
      end

      it "returns singular, lowercase symbol of class name" do
        expect(YFantasy::Thing.resource_name).to eq(:thing)
      end
    end

    describe ".collection_name" do
      it "returns nil for BaseResource" do
        expect(described_class.collection_name).to be_nil
      end

      it "returns plural, lowercase symbol of class name" do
        expect(YFantasy::Thing.collection_name).to eq(:things)
      end
    end
  end
end
