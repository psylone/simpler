require 'logger'

module Simpler
  class AppLogger
    def initialize(app, **options)
      @app = app
      @logger = Logger.new(options[:logfile])
    end

    def call(env)
      status, header, body = @app.call(env)
      request = Rack::Request.new(env)

      save_log_info(env)
      response = Rack::Response.new(body, status, header)
      response.finish
    end

    def save_log_info(env)
      @logger.info(env['Simpler.Log.Request'])
      @logger.info(env['Simpler.Log.Handler'])
      @logger.info(env['Simpler.Log.Parameters'])
      @logger.info(env['Simpler.Log.Response'])
    end
  end
end