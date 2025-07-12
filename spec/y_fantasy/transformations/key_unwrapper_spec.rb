# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::KeyUnwrapper do
  it "responds to :>> for chaining" do
    expect(described_class.new(:a)).to respond_to(:>>)
  end

  describe "#call" do
    it "unwraps a nested hash with 1 key" do
      data = {a: {b: "yo"}}
      unwrapper = described_class.new(:a)
      expect(unwrapper.call(data)).to eq({b: "yo"})
    end

    it "unwraps a nested hash with multiple keys" do
      data = {a: {b: {c: "yo"}}}
      unwrapper = described_class.new(:a, :b)
      expect(unwrapper.call(data)).to eq({c: "yo"})
    end
  end
end
