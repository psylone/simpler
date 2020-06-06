# frozen_string_literal: true

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
      env['resource.ids'] = resourse_id(path)
      env['resource.ids'].nil? ? nil : (path = create_correct_route(path))

      @routes.find { |route| route.match?(method, path) }
    end

    private

    def create_correct_route(path)
      path = path.split('/')
      path[2] = ':id'
      path.join('/')
    end

    def resourse_id(path)
      path = path.split('/')
      if path[2].nil?
        nil
      else
        { id: path[2].to_i }
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
