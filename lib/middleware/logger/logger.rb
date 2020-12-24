require 'logger'

class Logger
  def initialize(app, path)
     @app = app
     @logger = Logger.new(Simpler.root.join(path))
   end

  def call(env)
    @env = env
    @response = @app.call(env)
    @logger.info(log)
    @response
  end

  private

  def log
    "Request: #{@env["REQUEST_METHOD"]} #{@env["REQUEST_URI"]}\n" \
    "Handler: #{@env["simpler.controller"].class}##{@env["simpler.action"]}\n" \
    "Parameters: #{@env["simpler.params"]}\n" \
    "Response: #{@response[0]} [#{@response[1]}] #{@env["simpler.template-path"]}\n"
  end
end
