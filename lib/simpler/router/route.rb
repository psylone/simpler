module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        # it's from def route in routes - tests/:id
        @params_keys = params_keys_from_path(@path)
        @controller = controller
        @action = action

        @path_regexp = make_regexp(@path)
      end

      def match?(method, path)
        @method == method && path.match(@path_regexp)
      end

      def path_params(env)
        # it's from current route - tests/101
        path = env['PATH_INFO']
        params_values = params_values_from_path(path)
        @params = make_hash_from_params(@params_keys, params_values)
      end

      private

      def make_regexp(path)
        regexp = path
        keys = path.scan(/:\w+/)

        # меняем все :id и т.д. на регекспы, чтобы tests/:id распознало 101 как :id 
        #path_params_keys.each { |key| regexp = regexp.gsub(/#{key}/, '([1-9][0-9]*)') }
        # работает не только с числами  /categories/:slug/posts
        keys.each { |key| regexp = regexp.gsub(/#{key}/, '((?:)\w+)') }
        /#{regexp}$/
      end

      def make_hash_from_params(params_keys, params_values)
        Hash[params_keys.map(&:to_sym).zip(params_values)]
      end

      def params_keys_from_path(path)
        path.scan(/(?<=:)\w+/).map(&:to_sym)
      end

      def params_values_from_path(path)
        params = path.split('/').reject(&:empty?)
        # getting all the ids - all the Strings are nil
        params.map { |param| param.to_i if param.to_i > 0 }.compact
      end
    end
  end
end
