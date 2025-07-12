# frozen_string_literal: true

RSpec.describe YFantasy::SubresourceValidator do
  let(:test_class) do
    Class.new do
      include YFantasy::Subresourceable

      has_subresource :jawns, klass: Jawn
    end
  end

  let(:primary_subresource) { Class.new(YFantasy::BaseResource) }

  before do
    stub_const("Jawn", primary_subresource)
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
  end
end
