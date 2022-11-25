require_relative "router/route"

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
      method = env["REQUEST_METHOD"].downcase.to_sym
      path = env["PATH_INFO"]

      # @routes.find { |route| route.match?(method, path) }
      check_nested_route(method, path)
      find_route(method, path)
    end

    private

    def check_nested_route(method, path)
      path_details = path.split("/")

      find_nested_route(method, path, path_details) if path_details[2].to_i
    end

    def find_nested_route(method, path, path_details)
      controller_name = path_details[1]
      path_details[2] = ":id"

      path_for_matching = path_details.join("/")
      nested_route = find_route(method, path_for_matching)
      create_nested_route(method, path, nested_route, controller_name) if nested_route
    end

    def create_nested_route(method, path, nested_route, controller)
      route = find_route(method, path)
      route_point = controller + "#" + nested_route.action
      add_route(method, path, route_point) unless route
    end

    def add_route(method, path, route_point)
      route_point = route_point.split("#")
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

    def find_route(method, path)
      @routes.find do |route|
        route.match?(method, path)
      end
    end
  end
end
