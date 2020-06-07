# frozen_string_literal: true

class LogFormat
  HEADERS = %w[Request: Handler: Parameters: Response:].freeze

  def initialize(env, app)
    @env = env
    @app = app
    @request = Rack::Request.new(@env)
  end

  def formatter
    app_response = @app.call(@env)
    request = "Handler: #{@request.env['simpler.controller'].class}#""#{@request.env['simpler.action']}"
    handler = "Request: #{@request.env['PATH_INFO']}"
    parameters = "Parameters: #{@request.env['resource.ids']}"
    response = "Responce:  #{app_response[0]} #{app_response[1]['Content-Type']} #{template_path} \n"
    [handler, request, parameters, response].join("\n")
  end

  def template_path
    arr = [@request.env['simpler.controller'].name, @request.env['simpler.action']].join('/')
    arr + '.html.erb'
  end
end
