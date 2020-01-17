require 'yaml'
require 'singleton'
require 'sequel'
require_relative 'router'
require_relative 'controller'
require_relative '../extentions/events'

module Simpler
  class Application

    include Singleton
    include Events

    attr_reader :db
    event :make_response_event

    def initialize
      @router = Router.new
      @db = nil
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
      request = Rack::Request.new(env)
      route = @router.route_for(env)
      route.add_params_to(request)
      controller = route.controller.new(request)
      action = route.action

      fire(:make_response_event, controller, action)

      make_response(controller, action)
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

    def make_response(controller, action)
      controller.make_response(action)
    end

  end
end
