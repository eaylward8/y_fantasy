# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::ManagerUnwrapper do
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

    context "collection" do
      let(:data) do
        [
          {
            team_key: "whatever",
            managers: {
              manager: {
                manager_id: "1",
                nickname: "Osc"
              }
            }
          },
          {
            team_key: "anotha one",
            managers: {
              manager: {
                manager_id: "2",
                nickname: "Mr. Beef"
              }
            }
          }
        ]
      end

      let(:expected) do
        [
          {
            team_key: "whatever",
            managers: [
              {
                manager_id: "1",
                nickname: "Osc"
              }
            ]
          },
          {
            team_key: "anotha one",
            managers: [
              {
                manager_id: "2",
                nickname: "Mr. Beef"
              }
            ]
          }
        ]
      end

      it "transforms each item in collection" do
        expect(described_class.new(collection: true).call(data)).to eq(expected)
      end
    end
  end
end
