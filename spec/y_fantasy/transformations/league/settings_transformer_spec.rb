# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::League::SettingsTransformer do
  describe "#call" do
    let(:data) do
      {
        league_key: "123.l.456789",
        settings: {
          draft_type: "live",
          roster_positions: {
            roster_position: [
              {position: "QB"}
            ]
          },
          stat_categories: {
            stats: {
              stat: [
                {stat_id: 5, name: "Passing Touchdowns"}
              ]
            }
          },
          stat_modifiers: {
            stats: {
              stat: [
                {stat_id: 5, value: 4}
              ]
            }
          }
        }
      }
    end

    let(:expected) do
      {
        league_key: "123.l.456789",
        settings: {
          draft_type: "live",
          roster_positions: [
            {position: "QB"}
          ],
          stat_categories: [
            {stat_id: 5, name: "Passing Touchdowns"}
          ],
          stat_modifiers: [
            {stat_id: 5, value: 4}
          ]
        }
      }
    end

    it "transforms the settings value" do
      expect(YFantasy::Transformations::DefaultTransformer).to receive(:new).with(:roster_positions).and_call_original
      expect(YFantasy::Transformations::StatCategoriesTransformer).to receive(:new).and_call_original
      expect(YFantasy::Transformations::StatModifiersTransformer).to receive(:new).and_call_original
      expect(described_class.new.call(data)).to eq(expected)
    end
  end
end
