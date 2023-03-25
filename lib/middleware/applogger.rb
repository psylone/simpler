class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    request = Rack::Request.new(env)

    request_info(request)
    responce_info(status, headers, request)

    [status, headers, ["#{body}"]]
  end

  def request_info(request)
    log = "Request: #{request.env['REQUEST_METHOD']} #{request.env['REQUEST_URI']}
                                                  Handler: #{request.env['simpler.controller'].class.name}##{request.env['simpler.action']}
                                                  Parameters: #{request.env['simpler.params']}"

    @logger.info(log)
  end

  def responce_info(status, headers, request)
    log = "Response: #{status} #{headers['Content-Type']} #{request.env['simpler.file_path']} "

    @logger.info(log) if request.env['simpler.file_path']
  end
end
