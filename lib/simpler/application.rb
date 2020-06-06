# frozen_string_literal: true

require 'yaml'
require 'singleton'
require 'sequel'
require_relative 'router'
require_relative 'controller'
require 'byebug'
require_relative 'render/render'

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
      controller = route.controller.new(env)
      action = route.action

      make_response(controller, action)
    rescue NameError
      page_not_found
    end

    private

    def page_not_found
      [404, { 'Content-Type' => 'text/plain' }, ["Page not found! \n"]]
    end

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].sort.each { |file| require file }
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
