require 'logger'

class SimplerLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    response = @app.call(env)

    write_log(request, response)

    response
  end

  def write_log(request, response)
    time = Time.now
    method = request.request_method
    url = request.fullpath
    controller = request.env['simpler.controller'].class
    action = request.env['simpler.action']
    params = request.env['simpler.params'] || '-'
    status = response[0]
    type_response = response[1]['Content-Type']
    template = request.env['simpler.view_template']

    @logger << "#{time}
      Requiest: #{method} #{url}
      Handler: #{controller}##{action}
      Parameters: #{params}
      Respponse: #{status} [#{type_response}] #{template}\n"
  end
end
