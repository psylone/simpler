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
      path = path_formation(env)

      @routes.find { |route| route.match?(method, path) }
    end

    private

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

    def path_formation(env)
      path_info = env['PATH_INFO']
      if path_info.count("/") > 1
        path_array = path_info.delete_prefix("/").split("/")
        if path_array[1] =~ /\A\d+\z/
          params = path_array[1].to_i
          env["simpler.params"] = params
          "/#{path_array[0]}/:id"
        else
          path_info
        end
      else
        path_info
      end
    end

  end
end
