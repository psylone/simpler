require 'byebug'

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
        @method == method && match_path(path)
        
      end

      private

      def path_to_array(any_path)
        any_path.split('/').reject!{|i| i.empty?} 
      end

      def match_path(path)
        path_request = path_to_array(path)
        path_route = path_to_array(@path)
        
        compare(path_request, path_route)
      end

      def compare(request_path, route_path)
        return false unless request_path.size == route_path.size

        request_path.each_index do |i|
          if route_path[i] == request_path[i]
            next              
          end
          
          return false unless route_path[i] =~ /^:id$/
          get_params_from_request(route_path[i],request_path[i])          
        end
      end

      def get_params_from_request(key, value)
        key = key[1..-1] if key.chr == ":"
        key_sym = key.intern
        @params[key_sym] = value
      end
    end
  end
end
