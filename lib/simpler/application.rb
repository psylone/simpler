require 'yaml'
require 'singleton'
require 'sequel'
require_relative 'router'
require_relative 'controller'

module Simpler
  class Application

    include Singleton

    attr_reader :db, :controller, :action, :params

    def initialize
      @router = Router.new
      @db = nil

      @controller = nil
      @action = nil
      @params = nil
    end

    def bootstrap!
      setup_database
      require_app
      require_routes
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    def call(env)
      route = @router.route_for(env)

      return make_404_response(env) if route.nil?

      @controller = route.controller.new(env)
      @action = route.action
      @params = params_for_route(route, env)

      make_response(@controller, @action, @params)
    end

    private

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def setup_database
      database_config = YAML.load_file(Simpler.root.join('config/database.yml'))
      database_config['database'] = Simpler.root.join(database_config['database'])
      @db = Sequel.connect(database_config)
    end

    def make_response(controller, action, params)
      controller.make_response(action, params)
    end

    def make_404_response(env)
      Controller.new(env).response_404
    end

    def params_for_route(route, env)
      # TODO: query params
      if route.params.any?
        match = env['PATH_INFO'].match(route.path)

        return route.params.to_h { |key| [key, match[key]] }
      end

      {}
    end
  end
end
