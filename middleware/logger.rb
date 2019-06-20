require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    request_log(env)
    response_log(env, status, headers)
    [status, headers, body]
  end

  private

  def request_log(env)
    @logger.info("Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
    if env['simpler.controller']
      @logger.info("Handler: #{env['simpler.controller'].name.capitalize}Controller##{env['simpler.action']}")
      @logger.info("Parameters: #{env['simpler.controller'].params}")
    end
  end

  def response_log(env, status, headers)
    @logger.info("Response: #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]} [#{headers['Content-Type']}] #{env['simpler.template_path']}")
  end
  
end
