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
        @method == method && parse_params(path)
      end

    private

      def parse_params(path)
        route_path = @path.split("/")
        get_path = path.split("/")
        return false unless route_path.size == get_path.size

        params = {}
        route_path.each_with_index do |item, index|
          if item[0] == ":"
            params.merge!(item.gsub(":", "").to_sym => get_path[index])
          else
            return false unless item == get_path[index]
          end
        end
        @params = params
      end
    
    end
  end
end
