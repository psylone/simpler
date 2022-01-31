require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info("
    Request: #{env["REQUEST_METHOD"]} #{env["REQUEST_URI"]}
    Handler: #{env['simpler.handler']}
    Parameters: #{env['simpler.params']}
    Response: #{status} [#{headers['Content-Type']}] #{env['simpler.view']}
    ------------------------------------------------------")

    [status, headers, body]
  end

end
