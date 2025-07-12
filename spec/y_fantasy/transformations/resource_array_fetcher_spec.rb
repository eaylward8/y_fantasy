# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::ResourceArrayFetcher do
  describe "#call" do
    context "when value is an Array" do
      it "returns the value" do
        data = {
          food: [{name: "Tofu"}]
        }

        fetcher = described_class.new(:food)
        expect(fetcher.call(data)).to eq(data[:food])
      end
    end

    context "when value is not an Array" do
      it "returns the value wrapped in an Array" do
        data = {
          food: {name: "Tofu"}
        }

        fetcher = described_class.new(:food)
        expect(fetcher.call(data)).to eq([data[:food]])
      end
    end
  end
end
