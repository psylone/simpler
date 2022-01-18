# frozen_string_literal: true

require 'logger'

class LoggerMiddleware
  def initialize(app, options)
    @app = app
    @logger = Logger.new(options[:Logger])
  end

  def call(env)
    status, headers, body = @app.call(env)

    method = env['REQUEST_METHOD']
    uri = env['REQUEST_URI']

    controller = env['simpler.controller']
    action = env['simpler.action']
    template = env['simpler.template_name']

    @logger.info("Request: #{method}: #{uri}")
    if controller
      @logger.info("Handler: #{controller.class.name}##{action}")
      @logger.info("Params: #{controller.send(:params)}")
    end
    @logger.info("Response: #{status} [#{headers['Content-Type']}] #{template}")

    [status, headers, body]
  end
end
