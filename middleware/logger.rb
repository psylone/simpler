require 'logger'

class AppLogger

  def initialize(app, **options)


    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    logger_info(env)
    [status, headers, body]
  end

  private

  def logger_info(env)
    @response = Rack::Response.new
    @logger.info("
      Request: #{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}
      Handler: #{env['simpler.controller']}
      Parameters: #{env['simpler.parameters']}
      Response: #{@response.status} #{env['Content-Type']}")
    end

end
