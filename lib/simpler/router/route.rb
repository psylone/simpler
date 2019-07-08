module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path?(path)
      end

      def params(request)
        return {} unless @path.include? ':'

        @path.split('/').each.with_index.with_object({}) do |(part, index), result|
          next if part == request.path.split('/')[index]

          result[part.delete(':').to_sym] = request.path.split('/')[index]
        end
      end

      private

      def path?(path)
        return true if path == @path

        param_path?(path)
      end

      def param_path?(path)
        return false unless path.split('/').count == @path.split('/').count

        @path.split('/').each_with_index.all? do |part, index|
          part == path.split('/')[index] || part.include?(':')
        end
      end
    end
  end
end
