require 'logger'

class SimplerLogger
  def initialize(app, **options)
    @logger = Logger.new(Simpler.root.join(options[:logdev] || STDOUT))
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(log_info(env, status, headers))
    [status, headers, response]
  end

  private

  def log_info(env, status, headers)
    "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['simpler.route.params']}\n" \
    "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.view']}\n" \
  end
end
