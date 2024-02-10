require 'logger'

class RequestLogger
  def initialize(app)
    @app = app
    @logger = Logger.new(File.expand_path('../log/app.log', __dir__))
  end

  def call(env)
    request = Rack::Request.new(env)
    response = @app.call(env)

    logging(request, response)
    
    response
  end

  private

  def logging(request, response)
    status, headers, body = response
    content_type = headers['Content-Type']
    template = headers['Rander-Template-Path'] 
    
    @logger.info(
      "\nRequest: [#{request.request_method}] #{request.fullpath} \n" \
      "Handler: #{request.env['simpler.controller']}#"\
      "#{request.env['simpler.action']} \n" \
      "Parameters: #{request.params.inspect}\n" \
      "Response: [#{status}] #{content_type} #{template}\n"
    )
  end

end