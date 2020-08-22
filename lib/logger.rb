require 'logger'

class HTTPLogger

  def initialize(app)
    p "LOGGER!!!!"
    @main_app = app
    file = File.open('log/app.log', File::WRONLY | File::APPEND | File::CREAT)
    @logger = Logger.new(file)
  end

  def call(env)
    status, headers, body = @main_app.call(env)

    # Requests
    http_method = env['REQUEST_METHOD']
    uri = env['REQUEST_URI']
    controller = headers['Simpler-Controller']
    params = headers['Params']

    @logger.info(['Request: ', http_method, uri, controller, params])

    # Responses
    type = headers['Content-Type']
    template = headers['Rendered-Template']

    @logger.info(['Response: ', status, type, template])

    [status, headers, body]
  end

end