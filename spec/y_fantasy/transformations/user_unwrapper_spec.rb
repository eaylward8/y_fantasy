# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::UserUnwrapper do
  describe "#call" do
    it "unwraps users/user keys and removes guid" do
      data = {
        users: {
          user: {
            guid: "ABC123",
            data: {
              we: "want"
            }
          }
        }
      }

      expect(described_class.new.call(data)).to eq({data: {we: "want"}})
    end

    it "returns original data if there is no top-level users key" do
      data = {
        pizza: {
          users: "whatever"
        }
      }

      expect(described_class.new.call(data)).to eq(data)
    end
  end
end
