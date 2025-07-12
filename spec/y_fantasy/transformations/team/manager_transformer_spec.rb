# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::Team::ManagerTransformer do
  describe "#call" do
    context "one manager" do
      let(:data) do
        {
          team_key: "whatever",
          managers: {
            manager: {
              manager_id: "1",
              nickname: "Osc"
            }
          }
        }
      end

      let(:expected) do
        {
          team_key: "whatever",
          managers: [
            {
              manager_id: "1",
              nickname: "Osc"
            }
          ]
        }
      end

      it "unwraps nested hash and transforms managers value to array" do
        expect(described_class.new.call(data)).to eq(expected)
      end
    end

    context "two managers" do
      let(:data) do
        {
          team_key: "whatever",
          managers: {
            manager: [
              {
                manager_id: "1",
                nickname: "Osc"
              },
              {
                manager_id: "2",
                nickname: "Boss Pro"
              }
            ]
          }
        }
      end

      let(:expected) do
        {
          team_key: "whatever",
          managers: [
            {
              manager_id: "1",
              nickname: "Osc"
            },
            {
              manager_id: "2",
              nickname: "Boss Pro"
            }
          ]
        }
      end

      it "unwraps nested hash" do
        expect(described_class.new.call(data)).to eq(expected)
      end
    end
  end
end
