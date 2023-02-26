require 'rack'

class Logger

  def initialize(app)
    @app = app
  end
  
  def call(env)
    request = Rack::Request.new(env)
    log_request(request)
    status, headers, body = @app.call(env)
    log_response(status, headers)
    [status, headers, body]
  end
  
  def log_request(request)
    method = request.request_method
    url = request.url
    params = request.params
    path = request.path_info.split('/')
    controller = "#{path[1].capitalize}Controller"
    action = path[2]

   log("Request: #{method} #{url}")
   log("Handler: #{controller}##{action}")
   log("Parameters: #{params}")
  end

  def log_response(status, headers)
    content_type = headers['Content-Type']
    template = headers

    log("Response: #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]} [#{content_type}] #{template}")
  end
  
  def log(message)
    file = File.open('log/app.log', 'a')
    file.puts("#{message}")
    file.close
  end  

end    