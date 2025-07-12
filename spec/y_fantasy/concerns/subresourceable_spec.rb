# frozen_string_literal: true

RSpec.describe YFantasy::Subresourceable do
  let(:test_class) do
    Class.new do
      include YFantasy::Subresourceable

      has_subresource :cheesesteaks, klass: Cheesesteak
      has_subresource :pretzels, klass: Pretzel
    end
  end

  let(:primary_subresource) { Class.new(YFantasy::BaseResource) }
  let(:dependent_subresource) { Class.new(YFantasy::DependentSubresource) }

  before do
    stub_const("Cheesesteak", primary_subresource)
    stub_const("Pretzel", dependent_subresource)
    stub_const("TestClass", test_class)
  end

  describe ".has_subresources" do
    it "sets primary subresources" do
      expect(TestClass.primary_subresources).to match_array([:cheesesteaks])
    end

    it "sets dependent subresources" do
      expect(TestClass.dependent_subresources).to match_array([:pretzels])
    end

    it "sets subresources" do
      expect(TestClass.subresources).to match_array([:cheesesteaks, :pretzels])
    end

    it "defines subresource instance methods" do
      instance = TestClass.new

      TestClass.subresources.each do |subresource|
        expect(instance).to respond_to(subresource)
      end
    end

    it "returns subresource value if set" do
      instance = TestClass.new
      cheesesteaks = ["Wit", "Witout"]
      instance.instance_variable_set(:@cheesesteaks, cheesesteaks)

      expect(instance).to_not receive(:instance_variable_set)
      expect(instance.cheesesteaks).to match_array(cheesesteaks)
    end

    describe "fetching and setting subresources if not initially set" do
      context "non-dependent resource" do
        it "fetches and sets subresources" do
          instance = TestClass.new
          pretzels = ["CCP", "Mart"]

          expect(TestClass).to receive(:fetch_subresource).and_return(["fake_subresource"])
          expect(instance).to receive(:key)
          expect(instance).to receive(:instance_variable_set).with(:@pretzels, ["fake_subresource"]).and_return(pretzels)

          expect(instance.pretzels).to match_array(pretzels)
        end
      end
    end
  end
end
