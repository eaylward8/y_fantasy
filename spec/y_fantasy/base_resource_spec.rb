# frozen_string_literal: true

RSpec.describe YFantasy::BaseResource do
  let(:test_class) do
    Class.new(described_class) do

    end
  end

  before do
    stub_const("YFantasy::Thing", test_class)
  end

  describe "class methods" do
    describe ".for_current_user" do
      it "instantiates a CollectionProxy with scope_to_user set to true" do
        expect(YFantasy::CollectionProxy).to receive(:new).with("things", scope_to_user: true)
        YFantasy::Thing.for_current_user
      end
    end

    describe ".find_all" do
      it "instantiates a CollectionProxy with keys" do
        keys = %w[thingamajig whatchamacallit]
        expect(YFantasy::CollectionProxy).to receive(:new).with("things", keys)
        YFantasy::Thing.find_all(keys)
      end
    end

    describe ".find" do
      let(:key) { "thingamajig" }
      let(:resource_mapper) { instance_double(YFantasy::Transformations::ResourceMapper) }

      context "without subresources" do
        it "calls the API and instantiates a ResourceMapper" do
          expect(YFantasy::Api::Client).to receive(:get).with("thing", key, [])
          expect(YFantasy::Transformations::ResourceMapper).to receive(:new).with("thing", subresources: []).and_return(resource_mapper)
          expect(resource_mapper).to receive(:call)

          YFantasy::Thing.find(key)
        end
      end

      context "with subresources" do
        let(:subresources) { [:a, :b] }

        before do
          allow(YFantasy::SubresourceValidator).to receive(:validate!)
        end

        it "calls the API and instantiates a ResourceMapper" do
          expect(YFantasy::Api::Client).to receive(:get).with("thing", key, subresources)
          expect(YFantasy::Transformations::ResourceMapper).to receive(:new).with("thing", subresources: subresources).and_return(resource_mapper)
          expect(resource_mapper).to receive(:call)

          YFantasy::Thing.find(key, with: subresources)
        end
      end
    end
  end
end
