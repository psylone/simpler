module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :property, :value

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @property = define_property
        @value = nil
      end

      def match?(method, path)
        if @property
          path_prefix = @path[0..-(@property.size + 2)]
          @method == method && path.match(/#{path_prefix}\d+/)
          @value = path[/\d+\z/].to_i
        else
          @method == method && path.match(/#{@path}\z/)
        end
      end

      def parametric?
        !!@property
      end

      private

      def define_property
        @path[/:\w+/]&.[](1..-1)&.to_sym
      end

    end
  end
end
