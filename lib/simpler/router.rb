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
      # path = env['PATH_INFO']

      @routes.find { |route| route.match?(method, work_with_path(env)) }
    end

    private

    def work_with_path(env)
      path = env['PATH_INFO']
      p path.split('/')
      if path.split('/').last =~ /^\d+$/
        a = path.split('/')
        a.pop
        [a, ":id"].join('/')
      else
        path
      end
    end

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

  end
end
