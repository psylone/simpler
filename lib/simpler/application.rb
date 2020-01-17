require 'yaml'
require 'singleton'
require 'sequel'
require_relative 'router'
require_relative 'controller'

module Simpler
  class Application

    include Singleton

    attr_reader :db

    def initialize
      @router = Router.new
      @db = nil
      @on_call_handlers = []
    end

    def bootstrap!
      setup_database
      require_app
      require_routes
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    def on_call(&block)
      return unless block_given?

      on_call_handlers << block
    end

    def call(env)
      request = Rack::Request.new(env)
      route = @router.route_for(env)
      route.add_params_to(request)
      controller = route.controller.new(request)
      action = route.action

      execute_on_call(controller, action)

      make_response(controller, action)
    end

    private

    attr_reader :on_call_handlers

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

    def execute_on_call(controller, action)
      on_call_handlers.each do |handler|
        handler.call(controller, action)
      end
    end

    def make_response(controller, action)
      controller.make_response(action)
    end

  end
end
