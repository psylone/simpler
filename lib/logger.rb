require 'logger'
class AppLogger
  def initialize(app, **options)
    @app = app
    @logger = Logger.new(options[:logdev] || STDOUT)
  end

  def call(env)
    status, headers, body = @app.call(env)
    puts headers

    @logger.info(log(env, status, headers))
    [status, headers, body]
  end

  private

  def log(env,status,headers)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}\n \
    Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n \
    Parameters: #{env['simpler.controller'].request.params}\n \
    Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template']}\n"
  end
end
