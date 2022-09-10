# frozen_string_literal: true
require 'logger'

class Log

  def initialize(app, **options)
    @logger = Logger.new(options[:log_path] || STDOUT)
    @app = app
  end

  def call(env)
    response = @app.call(env)

    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}")
    @logger.info("Handler: #{env['simpler.controller'].name}##{env['simpler.action']}")
    @logger.info("Parameters: #{env['simpler.controller'].params}")
    @logger.info("Response: #{response[0]} [#{response[1]['Content-Type']}] #{env['simpler.template'] if ![:plain, :json].include?(env['simpler.format']) }")
    response
  end
end
