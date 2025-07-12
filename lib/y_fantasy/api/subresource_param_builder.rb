# frozen_string_literal: true

module YFantasy
  module Api
    class SubresourceParamBuilder
      SUBRESOURCE_MAP = {
        draft_results: :draftresults,
        ownership_percentage: :percent_owned,
        team_standings: :standings
      }

      def initialize(subresources = [], **options)
        @regular_subs, @nested_subs = normalize_subresources(subresources)
        @week = options.delete(:week)
        @options = options
      end

      def build
        @params = +""
        add_regular_subresource_segments
        add_nested_subresource_segments
        add_subresource_keys
        add_week
        @params
      end

      private

      def add_regular_subresource_segments
        return if @regular_subs.none?

        if @regular_subs.one? && @nested_subs.none?
          @params.concat("/#{@regular_subs.first}")
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
    end
  end
end
