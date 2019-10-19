module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        #@method == method && path.match(@path)
        @method == method && extract_params(path)
      end

      private

      def extract_params(path)
        params = {}
        route_path = @path.split('/').compact
        request_path = path.split('/').compact
        return false unless route_path.size == request_path.size

        route_path.each_with_index do |param, position|
          if param.start_with?(':')
            params.merge!(param.delete(':').to_sym => request_path[position])
          else
            return false unless param == request_path[position]
          end
        end
        @params = params
      end
    end
  end
end
