require 'logger'

class SimplerLogger
  
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end
  
  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(log_message(env, status, headers))

    [status, headers, body]
  end

  def log_message(env, status, headers)
    request = "Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
    handler = "Handler: #{headers['handler']}"
    parameters = "Parameters: #{headers[]}"
    response = "Response: #{status} #{headers['Content-type']} #{headers['template_path']}"
  end

end