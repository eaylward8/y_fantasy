# frozen_string_literal: true

module YFantasy
  class Game
    # Represents a position type within a fantasy game
    class PositionType < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] type
      # @return [String] position type abbreviation
      # @example "O", "K", "DT"
      option :type

      # @!attribute [r] display_name
      # @return [String] full name of the position type
      # @example "Offense", "Kickers", "Defense/Special Teams"
      option :display_name
    end
  end
end
