require 'logger'

class MyLogger
  def initialize(app, log_path)
    @app = app
    @logger = Logger.new(Simpler.root.join(log_path))
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(message(status, headers, env))

    [status, headers, response]
  end

  private

  def message(status, headers, env)
    "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['simpler.route_params']}\n" \
    "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template']}\n" \
  end
end