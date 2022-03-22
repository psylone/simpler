require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(create_log(env, status, headers))

    [status, headers, response]
  end

  def create_log(env, status, headers)
    action = "#{env['simpler.action']}"

    "\n
    Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
    Handler: #{env['simpler.controller'].class}##{action}
    Parameters: #{env['simpler.params']}
    Response: #{status} #{headers['Content-Type']} #{env['simpler.controller'].name}/#{action}.html.erb"
  end
end