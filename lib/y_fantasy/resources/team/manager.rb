# frozen_string_literal: true

module YFantasy
  class Team
    class Manager < DependentSubresource
      # Required attributes
      option :manager_id, type: Types::Coercible::Integer
      option :guid
      option :nickname

      # Optional attributes
      option :email, optional: true
      option :fantasy_profile_url, optional: true
      option :felo_score, type: Types::Coercible::Integer
      option :felo_tier
      option :image_url, optional: true
      option :is_comanager, optional: true, type: Types::Params::Bool
      option :is_commissioner, optional: true, type: Types::Params::Bool
      option :is_current_login, optional: true, type: Types::Params::Bool
      option :profile_image_url, optional: true
    end
  end
end
