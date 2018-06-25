require 'logger'

class AppLogger

  def initialize(app, **options)


    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)

    status, headers, body = @app.call(env)
    @response = Rack::Response.new
    @logger.info("
      Request: #{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}
      Handler: #{env['simpler.controller']}
      Parameters: #{env['simpler.parameters']}
      Response: #{@response.status} #{env['Content-Type']}")
    [status, headers, body]
  end

end
