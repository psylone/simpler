class Logger
  def initialize(app)
    @app = app
  end

  def call(env)
    log_file = File.open('log/app.log', 'a+')
    request = Rack::Request.new(env)
    status, headers, body = @app.call(env)
    response = Rack::Response.new(body, status, headers)
    write_log(log_file, request, status, headers)

    response.finish
  end

  private

  def write_log(file, request, status, headers)
    log_body = log_form(request, status, headers)
    file.write(log_body)

    file.close
  end

  def log_form(request, status, headers)
    method = request.request_method
    url = request.fullpath
    controller = request.env['simpler.controller']
    action = request.env['simpler.action']
    pattern = request.env['simpler.pattern']
    params = request.env['simpler.route_params']

    "#{Time.now}
    Request: #{method} #{url}
    Handler: #{controller.class.name}##{action}
    Parameters: #{params}
    Response: #{status} [#{headers['Content-Type']}] #{pattern} \n\n"
  end
end
