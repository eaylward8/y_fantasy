# frozen_string_literal: true

RSpec.describe YFantasy::BaseSubresource do
  let(:test_class) do
    Class.new(described_class)
  end

  before do
    stub_const("YFantasy::DummySubresource", test_class)
  end

  describe "class methods" do
    describe ".find" do
      let(:resource_name) { :food }
      let(:key) { "pretzel" }
      let(:dummy_transformer) { ->(data) { data } }

      it "calls the API and finds a transformer to map the data" do
        expect(YFantasy::Api::Client).to receive(:get).with(:food, keys: key)
        expect(YFantasy::Transformations).to receive(:transformer_for).with(:food).and_return(dummy_transformer)
        expect(dummy_transformer).to receive(:call)

        YFantasy::DummySubresource.find(resource_name, key)
      end
    end

    describe ".resource_name" do
      it "returns nil for BaseSubresource" do
        expect(described_class.resource_name).to be_nil
      end

      it "returns singular, lowercase symbol of class name" do
        expect(YFantasy::DummySubresource.resource_name).to eq(:dummy_subresource)
      end
    end
  end
end
