module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action, params)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = params
        @path_regexp = make_regexp(@path)
      end

      def match?(method, path)
        @method == method && path.match(@path_regexp)

        # if params.empty?
        #   @method == method && path.match(@path)
        # else
        #   # show SHOW not INDEX
        #   # apperently Do work with 2 levels - tests/101/questions/99
        #   @method == method && path.match(@path)


      #    @path.gsub(':id', params[0].to_s).match(path)
        # end
      end

      private

      def make_regexp(path)
        regexp = path
        path_params_keys = regexp.scan(/:\w+/).flatten
        # меняем все :id и т.д. на регекспы, чтобы tests/:id распознало 101 как :id 
        path_params_keys.each { |key| regexp = regexp.gsub(/#{key}/, '([1-9][0-9]*)') }
        /#{regexp}$/
      end
    end
  end
end
