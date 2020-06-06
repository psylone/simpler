require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(create_log_info(env, status, headers))
    [status, headers, response]
  end

  private

  def create_log_info(env, status, headers)
    "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
    Handler: #{env['simpler.controller'].class}##{env['simpler.action']}
    Parameters: #{env['simpler.params']}
    Response: #{status} #{headers['Content-Type']} #{env['simpler.template']}"
  end
end
