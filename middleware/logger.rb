require 'logger'

# logging
class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    r = @app.call(env)
    log = <<~LOG
    
      Request:    #{env['REQUEST_METHOD']} #{env['PATH_INFO']}
      Handler:    #{env['simpler.controller'].name}##{env['simpler.action']}
      Parameters: #{env['simpler.controller'].request.params}
      Response:   #{env['simpler.controller'].response.status}
                  #{env['simpler.controller'].response.content_type}
                  #{env['simpler.template']}
    LOG
    @logger.info(log)
    r
  end
end
