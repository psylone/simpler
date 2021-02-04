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

    def patch(path, route_point)
      add_route(:patch, path, route_point)
    end

    def delete(path, route_point)
      add_route(:delete, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']
      not_support_method = get_not_support_method(env)

      method = not_support_method || method

      route = @routes.find { |route| route.match?(method, path) } || not_found

      set_request_param(env, route.param_name) if route.param_name

      route
    end

    private

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      param_name = extract_param_name(path)
      
      route = Route.new(method, path, controller, action, param_name)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

    def not_found
      Route.new(nil, nil, HelpersController, 'not_found', nil)
    end

    def extract_param_name(path)
      /\/([a-z]+)\/*(:[a-z]*)*/.match(path)[2]
    end

    def set_request_param(env, param_name)
      param_name.sub!(':', '')
      request = Rack::Request.new(env)
      path = request.path

      param_value = path.split('/')[2]
      request.update_param(param_name.to_sym, param_value) if param_value
    end

    def get_not_support_method(env)
      request = Rack::Request.new(env)
      request.params['_method'].to_sym if request.params.has_key?('_method')
    end
  end
end
