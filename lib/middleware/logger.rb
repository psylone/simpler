require 'logger'

class AppLog

  def initialize(app)
    @app = app
    @logger = Logger.new('log/app.log')
  end

  def call(env)
    status, headers, response = @app.call(env)
    log = build_log(env, status, headers)

    @logger.info(log)
    [status, headers, response]
  end

  private

  def build_log(env, status, headers)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['simpler.params']}\n" \
    "Response: #{status} #{headers['Content-Type']} #{env['simpler.render_view']}\n" \
  end

end
