require 'logger'

class SimplerLogger
  
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
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}" \
    "Parameters: #{env['simpler.params']}" \
    "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.render_view']}" \
  end
end