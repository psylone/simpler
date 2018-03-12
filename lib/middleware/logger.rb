require 'logger'

class AppLogger

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
    controller = if env['simpler.controller'].nil?
                   'UnknownController'
                 else
                   "#{env['simpler.controller'].name.capitalize}Controller"
                 end
    action = env['simpler.action'].nil? ? 'UnknownAction' : env['simpler.action']
    "Handler: #{controller}##{action}"
  end

  def parameters(env)
    if env['simpler.controller'].nil?
      'Parameters: Unknown'
    else
      "Parameters: #{env['simpler.controller'].send :params}"
    end
  end

  def response(env, status, headers)
    content_type = headers['Content-Type'].nil? ? 'Unknown' : headers['Content-Type']
    template = env['simpler.template'].nil? ? 'Unknown' : env['simpler.template']

    "Response: #{status} #{content_type} #{template}"
  end

end