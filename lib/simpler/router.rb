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
      params = extract_params_from_path(path)
      @route = @routes.find { |route| route.match?(method, path) }
      if @route
        env['simpler.path_params'] = params unless params.empty?
      end
      @route
    end

    private

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      params = extract_params_from_path(path)
      route = Route.new(method, path, controller, action, params)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

    def extract_params_from_path(path)
      params = path.split('/').reject(&:empty?)
      # getting all the ids - all the Strings is nil
      params.map { |param| param.to_i if param.to_i > 0 }.reject(&:nil?)
    end
  end
end
