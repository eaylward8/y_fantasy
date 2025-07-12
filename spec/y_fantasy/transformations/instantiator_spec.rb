# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::Instantiator do
  let(:test_class) do
    Class.new do
      def initialize(a:, b:)
        @a, @b = a, b
      end
    end
  end

  before do
    stub_const("TestClass", test_class)
  end

  describe "#call" do
    context "when instantiating a single instance" do
      it "instantiates class with provided args" do
        instantiator = described_class.new(TestClass)
        args = {a: 1, b: 2}
        expect(instantiator.call(args)).to be_a(TestClass)
      end
    end

    context "when instantiating a collection of instances" do
      it "instantiates classes with provided args" do
        instantiator = described_class.new(TestClass, collection: true)
        args = [
          {a: 1, b: 2},
          {a: 3, b: 4}
        ]
        results = instantiator.call(args)

        expect(results).to all(be_a(TestClass))
      end
    end
  end
end
