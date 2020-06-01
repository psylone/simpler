require 'singleton'
require_relative 'router'
require_relative 'controller'

module Simpler
  class Application

    include Singleton

    def initialize
      @router = Router.new
    end

    def bootstrap!
      require_app
      require_routes
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    def call(env)
      route = @router.route_for(env) # нужный объект класса Route который находится в массиве @router а попадает туда объект из за метода add_route в классе Router
      controller = route.controller.new(env)
      action = route.action

      make_response(controller, action)
    end

    private

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def make_response(controller, action)
      controller.make_response
    end

  end
end
