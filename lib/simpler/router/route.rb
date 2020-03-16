# frozen_string_literal: true

module Simpler
  class Router
    # Single route for request routing
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @path_template = @path.split '/'
      end

      def match?(env)
        @method == extract_method(env) && path_match?(extract_path(env))
      end

      def path_params(env)
        path_parts = extract_path(env).split '/'
        return unless path_parts.count == @path_template.count

        params = {}
        @path_template.each_with_index do |template, index|
          if template[0] == ':'
            params[template[1..-1].to_sym] = path_parts[index]
          end
        end

        params
      end

      def extract_method(env)
        env['REQUEST_METHOD'].downcase.to_sym
      end

      def extract_path(env)
        env['PATH_INFO']
      end

      private

      def path_match?(path)
        path_parts = path.split '/'
        return unless path_parts.count == @path_template.count

        return true if @path_template.empty?

        @path_template.each_with_index do |template, index|
          template[0] == ':' || template == path_parts[index] || break
        end != nil
      end
    end
  end
end
