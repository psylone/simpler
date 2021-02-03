require 'logger'
# init
class SimplerLogger
  def initialize(app, log_path)
    @logger = Logger.new(Simpler.root.join(log_path))
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(log(status, headers, env))

    [status, headers, response]
  end

  private

  def log(status, headers, env)
    "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['QUERY_STRING']}\n" \
    "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template_path']}\n" \
    "Action: #{env['simpler.action']}\n" \
    "Params: #{env['simpler.params']}\n" \
    "#{env}\n" \
  end
end
