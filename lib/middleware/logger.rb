require 'logger'

class SimplerLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(add_to_log(env, status, headers))
    [status, headers, body]
  end

  private

  def add_to_log(env, status, headers)
    "\n
    #{request(env)}
    #{handler(env)}
    #{parameters(env)}
    #{response(env, status, headers)}
    \n"
  end

  def request(env)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}"
  end

  def handler(env)
    controller_name = "#{env['simpler.controller'].name.capitalize}Controller"
    action = env['simpler.action']

    "Handler: #{controller_name}##{action}"
  end

  def parameters(env)
    "Parameters: #{env['simpler.route_params']}"
  end

  def response(env, status, headers)
    template = env['simpler.template'] if env['simpler.template'].is_a?(String)

    "Response: #{status} [#{headers['Content-Type']}] #{template}"
  end
end
