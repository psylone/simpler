require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(log_message(env, status, headers))

    [status, headers, body]
  end

  private

  def log_message(env, status, headers)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{Rack::Utils.parse_nested_query(env['QUERY_STRING'])}"
    "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template_path']}\n" \
  end
end
