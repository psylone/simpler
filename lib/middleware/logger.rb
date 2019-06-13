require 'logger'

class SimplerLogger

  def initialize(app, log_path)
    @app = app
    @logger = Logger.new(Simpler.root.join(log_path))
  end

  def call(env)
    @request = Rack::Request.new(env)    
    @response = @app.call(env)
    @logger.info(message)
    @response
  end

  private

  def message
    "\nRequest: #{@request.env["REQUEST_METHOD"]} #{@request.env["REQUEST_URI"]}\n" \
    "Handler: #{@request.env["simpler.controller"].class}##{@request.env["simpler.action"]}\n" \
    "Parameters: #{@request.env["simpler.route_params"]}\n" \
    "Response: #{@response[0]} [#{@response[1]["Content-Type"]}] #{@request.env["simpler.template_path"]}\n"
  end
end