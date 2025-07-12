# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::KeyUnwrapper do
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

    it "fails if the value to be unwrapped is not a hash" do
      data = {a: {b: ["yo"]}}
      unwrapper = described_class.new(:a, :b)
      expect { unwrapper.call(data) }.to raise_error(ArgumentError)
    end
  end
end
