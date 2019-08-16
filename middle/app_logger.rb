require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(log_body(env))
    [status, headers, body]
  end

  def log_body(env)
    @env = env
    if controller
      "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}" + "#{env['QUERY_STRING']}\n" +
      "Handler: #{controller.class.name}\##{action}\n" +
      "Parametrs: #{controller.request.params}\n" +
      "Response: #{controller.response.status}, #{controller.response['Content-Type']}, #{env['simpler.template']} \n"
    else
      "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}\n" +
      "Handler not found."
    end
  end

  private

  def controller
    @env['simpler.controller']
  end

  def action
    @env['simpler.action']
  end

end
