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
      path = env['PATH_INFO']

      @routes.find { |route| route.match?(method, path) }
    end

    private

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      params = params_from_path(path)
      path = remove_params_from_path(path)
      action = route_point[1]
      route = Route.new(method, path, controller, action, params)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

    def params_from_path(path)
      semicolon_index = path.rindex(/\:/)
      path[semicolon_index, path.size] unless semicolon_index.nil?
    end

    def remove_params_from_path(path)
      semicolon_index = path.rindex(/\:/)
      return path if semicolon_index.nil?
      path[0, semicolon_index]
    end

  end
end
