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
        @method == method && set_params(path)
      end

    private
 
      def set_params(path)
        path_element = path.split('/') 
        request_element = @path.split('/') 
      
        path_element.each_with_index do |element, index|
          if element.start_with?(':')
            param_name = element.gsub(':', '').to_sym
            @params[param_name] = request_element[index]
          end
        end
      end  
    end
  end
end
