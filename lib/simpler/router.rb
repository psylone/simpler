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

      reg = %r[^((\/[a-z]+\/(:[a-z_]*id|[0-9]+))+)|(\/[a-z]+\/(:[a-z_]*id|[0-9]+)\/[a-z]+)$]

      @routes.find do |route|
        if path.match?(reg) && route.path.match?(reg)
          set_route_params(route.path, path, env)
          route
        else
          env["simpler.route_params"] = ""
          route.match?(method, path)
        end
      end

    end

    private

    def set_route_params(route_path, request_path, env)
      route_path = route_path.split("/")
      request_path = request_path.split("/")

      parameters = route_path.zip(request_path)

      #delete from array dupplicate values and null values
      clear_parameters = parameters.reject do |p|
        p[0] == p[1]
      end

      clear_parameters.each { |param| env["simpler.route_params"] = { param[0][1..-1].to_sym => param[1] } }
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
