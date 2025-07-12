# frozen_string_literal: true

RSpec.describe YFantasy::Concerns::Subresourceable do
  let(:test_class) do
    Class.new do
      include YFantasy::Concerns::Subresourceable

      has_subresources :tacos, :burgers
      has_subresources :pizzas, :pastas, dependent: true
    end
  end

  before do
    stub_const("TestClass", test_class)
  end

  describe ".has_subresources" do
    it "sets primary subresources" do
      expect(TestClass.primary_subresources).to match_array([:tacos, :burgers])
    end

    it "sets dependent subresources" do
      expect(TestClass.dependent_subresources).to match_array([:pizzas, :pastas])
    end

    it "sets subresources" do
      expect(TestClass.subresources).to match_array([:tacos, :burgers, :pizzas, :pastas])
    end

    it "defines subresource instance methods" do
      instance = TestClass.new

      TestClass.subresources.each do |subresource|
        expect(instance).to respond_to(subresource)
      end
    end

    it "returns subresource value if set" do
      instance = TestClass.new
      burgers = ["BBQ Burger", "Black Bean Burger"]
      instance.instance_variable_set(:@burgers, burgers)

      expect(instance).to_not receive(:instance_variable_set)
      expect(instance.burgers).to match_array(burgers)
    end

    it "fetches and sets subresources if not set" do
      instance = TestClass.new
      tacos = ["Awesome Taco", "Spicy Taco"]

      expect(TestClass).to receive(:fetch_subresource).and_return(["fake_subresource"])
      expect(instance).to receive(:key)
      expect(instance).to receive(:instance_variable_set).with(:@tacos, ["fake_subresource"]).and_return(tacos)

      expect(instance.tacos).to match_array(tacos)
    end
  end
end
