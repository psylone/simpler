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
      resource_path = split_resource_path_and_id(path, '/')[0]
      id = split_resource_path_and_id(path, '/')[1]
      @routes.find { |route| route.match?(method, path, id) }
    end

    private

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      resource_path = split_resource_path_and_id(path, '/:')[0]
      with_id = !split_resource_path_and_id(path, '/:')[1].nil?
      route = Route.new(method, resource_path, controller, action, with_id)
      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

    def split_resource_path_and_id(path, separator)
      path.split(separator).reject { |part| part.empty? }
    end

  end
end
