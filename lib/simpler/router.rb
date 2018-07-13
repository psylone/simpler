require_relative 'router/route'

module Simpler
  class Router

    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path   = env['PATH_INFO']

      current_route = @routes.find { |route| route.match?(method, path) }
      env['action_params'] = current_route.params unless current_route.nil?
      current_route.nil? ? not_found(path) : current_route
    end

    private


    def not_found(path)
      Route.new(:get, path, controller_from_string('defaults'), 'not_found')
    end

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller  = controller_from_string(route_point[0])
      action      = route_point[1]
      route       = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

  end
end
