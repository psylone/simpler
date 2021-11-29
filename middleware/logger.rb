require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    @logger.info(create_log(env, status, headers))
    @logger.close

    [status, headers, response]
  end

  def create_log(env, status, headers)
    action = "#{env['simpler.action']}"

    "\n
    Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
    Handler: #{env['simpler.controller'].class}##{action}
    Parameters: {'category' => 'Backend'}
    Response: #{status} #{headers['Content-Type']} #{env['simpler.controller'].name}/#{action}.html.erb"
  end
end