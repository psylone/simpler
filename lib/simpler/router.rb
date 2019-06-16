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
      url_path = env['PATH_INFO']

      @routes.find { |route| route.match?(method, url_path) }
    end

    private

    def add_route(method, route_path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]

      route = Route.new(method, route_path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end
  end
end
