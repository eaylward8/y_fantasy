# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::BaseTransform do
  let!(:function) { double("Function") }
  let(:test_class) do
    Class.new(described_class) do
      def initialize(function)
        @function = function
        super
      end
    end
  end

  let(:test_class_no_function) do
    Class.new(described_class)
  end

  context "when @function ivar is set appropriately" do
    before do
      allow(function).to receive(:is_a?).with(Dry::Transformer::Function).and_return(true)
    end

    it "does not raise error on instantiation" do
      expect { test_class.new(function) }.to_not raise_error
    end

    it "responds to #>> for chaining" do
      expect(test_class.new(function)).to respond_to(:>>)
    end

    it "responds to #call" do
      expect(test_class.new(function)).to respond_to(:call)
    end
  end

  context "when @function ivar is not set" do
    it "raises" do
      expect { test_class_no_function.new }.to raise_error("Subclass must set @function instance variable")
    end
  end
end
