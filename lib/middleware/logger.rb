class AppLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    log = log_message(env, status, headers)
    File.open('log/app.log', 'a+') { |file| file.write(log) }
    [status, headers, response]
  end

  private

  def log_message(env, status, headers)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['simpler.params']}\n" \
    "Response: #{status} #{headers['Content-Type']} #{env['simpler.render_view']}\n" \
  end
end
