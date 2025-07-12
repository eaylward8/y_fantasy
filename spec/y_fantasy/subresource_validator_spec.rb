# frozen_string_literal: true

RSpec.describe YFantasy::SubresourceValidator do
  let(:test_class) do
    Class.new do
      include YFantasy::Subresourceable

      has_subresource :jawns, klass: Jawn
    end
  end

  let(:subresource_1) do # Jawn
    Class.new(YFantasy::BaseResource) do
      include YFantasy::Subresourceable

      has_subresource :wooders, klass: Wooder
    end
  end

  let(:subresource_2) do # Wooder
    Class.new(YFantasy::BaseResource) do
      include YFantasy::Subresourceable

      has_subresource :hoagies, klass: Hoagie
    end
  end

  let(:subresource_3) { Class.new(YFantasy::BaseResource) } # Hoagie

  before do
    stub_const("Hoagie", subresource_3)
    stub_const("Wooder", subresource_2)
    stub_const("Jawn", subresource_1)
    stub_const("TestClass", test_class)
  end

  describe "#validate!" do
    it "returns true if subresources exist on given class" do
      validator = described_class.new(TestClass, [:jawns])
      expect(validator.validate!).to be(true)
    end

    it "returns true if no subresources are provided" do
      validator = described_class.new(TestClass)
      expect(validator.validate!).to be(true)
    end

    it "raises if subresources do not exist on given class" do
      validator = described_class.new(TestClass, [:things])
      expect { validator.validate! }.to raise_error(YFantasy::SubresourceValidator::InvalidSubresourceError, /things is not a valid subresource/)
    end

    it "returns true for valid nested subresources" do
      validator = described_class.new(TestClass, [{jawns: :wooders}])
      expect(validator.validate!).to be(true)
    end

    it "returns true for valid, deeply nested subresources" do
      validator = described_class.new(TestClass, [{jawns: {wooders: :hoagies}}])
      expect(validator.validate!).to be(true)
    end

    it "raises for invalid nested subresources" do
      validator = described_class.new(TestClass, [{jawns: :things}])
      expect { validator.validate! }.to raise_error(YFantasy::SubresourceValidator::InvalidSubresourceError, /things is not a valid subresource/)
    end
  end
end
