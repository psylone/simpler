require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(message(env, status, headers))
    [status, headers, response]
  end

  private

  def message(env, status, headers)
    "\n    #{request(env)}
    #{handler(env)}
    #{parameters(env)}
    #{response(env, status, headers)}\n"
  end

  def request(env)
    "Request:    #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}"
  end

  def handler(env)
    "Handler:    #{env['simpler.controller'].name.capitalize}Controller##{env['simpler.action']}"
  end

  def parameters(env)
    "Parameters: #{env['simpler.controller'].send :params}"
  end

  def response(env, status, headers)
    "Response:   #{status} #{headers['Content-Type']} #{env['simpler.template_path']}"
  end

end