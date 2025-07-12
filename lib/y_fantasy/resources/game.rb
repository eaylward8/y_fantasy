# frozen_string_literal: true

module YFantasy
  class Game < BaseResource
    # TODO: make constant of all valid yahoo game codes (nfl, nba, nfls, etc)

    # Required attributes
    option :game_key
    option :game_id
    option :name
    option :code
    option :type
    option :url
    option :season
    option :is_registration_over, type: Types::Params::Bool
    option :is_game_over, type: Types::Params::Bool
    option :is_offseason, type: Types::Params::Bool

    # Optional attributes
    option :current_week, optional: true
    option :is_contest_reg_active, optional: true, type: Types::Params::Bool
    option :is_contest_over, optional: true, type: Types::Params::Bool
    option :has_schedule, optional: true, type: Types::Params::Bool

    # Subresources
    option :game_weeks, optional: true, type: array_of(GameWeek)
    option :position_types, optional: true, type: array_of(PositionType)
    option :roster_positions, optional: true, type: array_of(RosterPosition)
    option :stat_categories, optional: true, type: array_of(StatCategory)

    option :groups, optional: true, type: array_of(Group)
    option :leagues, optional: true, type: array_of(League)

    has_subresource :game_weeks, klass: GameWeek
    has_subresource :position_types, klass: PositionType
    has_subresource :roster_positions, klass: RosterPosition
    has_subresource :stat_categories, klass: StatCategory

    has_subresource :groups, klass: Group
    has_subresource :leagues, klass: League

    def self.find_all_by_code(codes, with: [], **options)
      subresources = Transformations::T.wrap_in_array(with)
      SubresourceValidator.validate!(self, subresources)
      # TODO: remove
      puts "\n YFantasy::Api::Client.get(games, '#{codes}', #{subresources}) \n"
      data = YFantasy::Api::Client.get(:games, game_codes: codes, subresources: subresources, **options)
      Transformations::CollectionTransformer.new(:games).call(data)
    end
  end
end
