require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    @logger.info(log(env, status, headers))

    [status, headers, body]
  end

  private

  def log(env, status, headers)
    "\n#{request(env)}\n#{handler(env)}\n#{parameters(env)}\n#{response(env, status, headers)}"
  end

  def request(env)
    "Request: #{env['REQUEST_METHOD']}  #{env['REQUEST_URI']}"
  end

  def handler(env)
    if env['simpler.controller']
      "Handler: #{env['simpler.controller'].name.capitalize}Controller##{env['simpler.action']}"
    else
      "Handler: none"
    end
  end

  def parameters(env)
    "Parameters: #{env['simpler.params']}"
  end

  def response(env, status, headers)
    "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.view']}"
  end
end
