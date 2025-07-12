# frozen_string_literal: true

RSpec.describe YFantasy::BaseResource do
  let(:test_class) do
    Class.new(described_class)
  end

  before do
    stub_const("YFantasy::Thing", test_class)
  end

  describe "class methods" do
    describe ".find_all" do
      let(:keys) { %w[cheesesteak hoagie] }
      let(:thing_transformer) { ->(data) { data } }
      let(:things) { Array.new(2, YFantasy::Thing.new) }

      it "instantiates a CollectionProxy with keys" do
        expect(YFantasy::Api::Client).to receive(:get).with(:things, keys: keys, subresources: [], scope_to_user: false)
        expect(YFantasy::Transformations::CollectionTransformer).to receive(:new).with(:things).and_return(thing_transformer)
        expect(thing_transformer).to receive(:call).and_return(things)

        YFantasy::Thing.find_all(keys)
      end
    end

    describe ".find" do
      let(:key) { "pretzel" }
      let(:thing_transformer) { ->(data) { data } }
      let(:thing) { YFantasy::Thing.new }

      it "calls the API and finds a transformer to map the data" do
        expect(YFantasy::Api::Client).to receive(:get).with(:thing, keys: key, subresources: [])
        expect(YFantasy::Transformations).to receive(:transformer_for).with(:thing).and_return(thing_transformer)
        expect(thing_transformer).to receive(:call).and_return(thing)

        YFantasy::Thing.find(key)
      end
    end

    describe ".fetch_subresource" do
      let(:key) { "wooder" }
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
