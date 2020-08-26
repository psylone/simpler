require 'logger'

class LoggerHttp

  def initialize(app)
    @app = app
    @logger = Logger.new(Simpler.root.join('log/app.log'))
  end

  def call(env)
    request = Rack::Request.new(env)
    response = @app.call(env)
    log(request, response)

    response
  end

  private

  def log(request, response)
    @logger.info("Request: #{request.request_method} #{path_info(request)}")
    @logger.info("Handler: #{handler_info(request)}")
    @logger.info("Parameters: #{params(request)}")
    @logger.info("Response: #{status(response)} [#{content_type(response)}]
      #{template(request)}")
  end

  def path_info(request)
    [request.path_info, request.query_string].reject(&:empty?).join('?')
  end

  def handler_info(request)
    if request.env['simpler.controller'].nil?
      "none"
    else
      "#{request.env['simpler.controller'].class.name}#{request.env['simpler.action']}"
    end
  end

  def params(request)
    request.env['simpler.all_params'] || request.params
  end

  def status(response)
    [response[0], Rack::Utils::HTTP_STATUS_CODES[response[0]]].join(' ')
  end

  def content_type(response)
    response[1]['Content-Type']
  end

  def template(request)
    return "custom: #{request.env['simpler.template'].keys[0]}" if request.env['simpler.template'].is_a?(Hash)

    return "none" if request.env['simpler.controller'].nil?

    path = request.env['simpler.template'] || [request.env['simpler.controller'].name,
     request.env['simpler.action']].join('/') "#{path}.html.erb"
  end
end
