class Logger
  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    status, headers, body = @app.call(env)

    log_content = collect_logs(status, headers, body)
    logging(log_content)

    [status, headers, body]
  end

  def logging(content)
    filepath = File.expand_path('log/app.log')
    write_mode = File.exist?(filepath) ? 'a' : 'w'
    File.write(filepath, content, mode: write_mode)
  end

  def collect_logs(status, headers, _body)
    controller = @env['simpler.controller'].class.name
    action = @env['simpler.action']
    template = @env['simpler.template'] || @env['simpler.render']
    parameters = @env['params']
    "
    Request: #{@env['REQUEST_METHOD']}
    Handler: #{controller}##{action}
    Parameters: #{parameters}
    Response: #{status} [#{headers['Content-Type']}] #{template}
    "
  end
end
