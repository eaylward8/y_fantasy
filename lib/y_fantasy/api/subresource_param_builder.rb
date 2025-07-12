# frozen_string_literal: true

module YFantasy
  module Api
    class SubresourceParamBuilder
      SUBRESOURCE_MAP = {
        draft_results: :draftresults,
        ownership_percentage: :percent_owned,
        team_standings: :standings
      }

      PLAYER_FILTERS = [
        :count,
        :position,
        :search,
        :sort,
        :sort_type,
        :start,
        :status
      ].freeze

      def initialize(subresources = [], **options)
        @regular_subs, @nested_subs = normalize_subresources(subresources)
        @week = options.delete(:week)
        @player_filters = set_player_filters(options)
        @options = options
      end

      def build
        @params = +""
        add_regular_subresource_segments
        add_nested_subresource_segments
        add_subresource_keys
        add_week
        add_player_filters
        @params
      end

      private

      def add_regular_subresource_segments
        return if @regular_subs.none?

        if @regular_subs.one? && @nested_subs.none?
          @params.concat("/#{@regular_subs.first}")
        elsif @regular_subs.size > 1 && @regular_subs.include?(:players) && !@player_filters.empty?
          non_player_subs = @regular_subs.select { |sub| sub != :players }
          @params.concat(";out=#{non_player_subs.join(",")}").concat("/players")
        else
          @params.concat(";out=#{@regular_subs.join(",")}")
        end
      end

      def add_nested_subresource_segments
        return if @nested_subs.none?

        if @nested_subs.one?
          key = @nested_subs.first.keys.first
          val = @nested_subs.first[key]

          @params.concat("/#{key}")
          @params.concat("/#{val}") if val.is_a?(Symbol)
          @params.concat("/#{val.keys.first}/#{val.values.first}") if val.is_a?(Hash)
          @params.concat(";out=#{val.join(",")}") if val.is_a?(Array)
        else
          raise self.class::Error.new("Not possible to construct a URL with 2+ sets of nested subresources: #{@nested_subs}")
        end
      end

      def add_subresource_keys
        return unless options_include_subresource_keys?

        @options.each_pair do |k, v|
          k_str = Transformations::T.pluralize(k.to_s.sub("_keys", ""))
          if @params.include?("/#{k_str}")
            @params.sub!(k_str, "#{k_str};#{k}=#{v.join(",")}")
          end
        end
      end

      def options_include_subresource_keys?
        @options.keys.map(&:to_s).any? { |s| s.end_with?("_keys") }
      end

      def add_week
        return if @week.nil?

        case @params
        when /\/(roster|scoreboard)/
          @params.sub!(/\/(?<res>roster|scoreboard)/, "/\\k<res>;week=#{@week}")
        when /\/matchups/
          @params.sub!("matchups", "matchups;weeks=#{@week}")
        when /\/stats/
          @params.sub!("stats", "stats;type=week;week=#{@week}")
        end
      end

      def add_player_filters
        return if @player_filters.empty? || !@params.match?(/players/)

        player_params = +""
        @player_filters.each { |k, v| player_params.concat(k.to_s, "=", v.to_s, ";") }
        player_params.slice!(-1)
        @params.sub!("players", "players;#{player_params}")
      end

      def set_player_filters(options)
        options.each_with_object({}) do |(k, v), h|
          h[k] = v if PLAYER_FILTERS.include?(k)
        end
      end

      def normalize_subresources(subs)
        @regular_subs = []
        @nested_subs = []

        subs.each do |sub|
          if sub.is_a?(Symbol)
            @regular_subs << (SUBRESOURCE_MAP[sub] || sub)
          end

          if sub.is_a?(Hash)
            sub.each_pair do |key, nested_subs|
              nested_subs = Transformations::T.wrap_in_array(nested_subs)
              nested_subs = nested_subs.map { |nested_sub| SUBRESOURCE_MAP[nested_sub] || nested_sub }
              @nested_subs << (nested_subs.one? ? {key => nested_subs.first} : {key => nested_subs})
            end
          end
        end

        [@regular_subs, @nested_subs]
      end

      class Error < StandardError
      end
    end
  end
end
