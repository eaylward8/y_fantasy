# frozen_string_literal: true

module YFantasy
  class Stat < DependentSubresource
    # Required attributes
    option :stat_id, type: Types::Coercible::Integer

    # TODO: Most often this can be coerced to a Float, but there are some weird stats that return things like:
    # "-" or "2478/5152"
    # So, not going to coerce this until everything is working and I figure out what kinds of values are returned.
    # Maybe not worth coercing at all.
    option :value
  end
end
