require_relative 'router/route'

module Simpler
  class Router

    def initialize
      @routes = []
    end

    def get(full_path, route_point)
      add_route(:get, full_path, route_point)
    end

    def post(full_path, route_point)
      add_route(:post, full_path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']

      matched_route = @routes.find { |route| route.match?(method, path) }
      env['simpler.params'].update(matched_route.params) if matched_route
      matched_route
    end

    private

    def add_route(method, full_path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      params = find_params(full_path)

      route = Route.new(method, full_path, controller, action, params)
      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

    def find_params(full_path)
      segments = full_path.split('/').reject(&:empty?)
      segments.map { |element| element.to_i if element.to_i > 0 }
    end

  end
end
