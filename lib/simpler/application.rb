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
      if route.nil?
        self.not_found
      else
        controller = route.controller.new(env)
        action = route.action

        route.add_params(env['PATH_INFO'])
        env['simpler.params'] = route.params


        make_response(controller, action)
      end
    end

    private

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def not_found
      response = Rack::Response.new(
        ['404 Not Found'],
        404,
        { 'Content-Type' => 'text/plain' }
      )
      response.finish
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
