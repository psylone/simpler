class Logger
  def initialize(app)
    @app = app
    log_path = Simpler.root.join('log/app.log')
    @log_file = File.open(log_path, 'a')
  end

  def call(env)
    @env = env
    @request = Rack::Request.new(env)
    @status, @headers, @body = @app.call(env)
    update_log
    [@status, @headers, @body]
  end

  private

  def update_log
    log_request
    log_params
    log_handler
    log_response
  end

  def log_request
    request = "Request: #{@request.request_method} #{@request.path}\n"
    @log_file.write(request)
  end

  def log_params
    @log_file.write @request.params.to_s + "\n"
  end

  def log_handler
    controller = @request.env['simpler.controller'].class.name
    handler = "Handler: #{controller}##{@request.env['simpler.action']}\n"
    @log_file.write(handler)
  end

  def log_response
    content_type = @headers['Content-Type']
    template = @headers['X-Template']
    response = "Response: #{@status} [#{content_type}] #{template}\n"
    @log_file.write(response)
  end
end
