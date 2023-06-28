require 'logger'

class AppLogger
  def initialize(app, options = {})
    @logger = Logger.new(options[:logdev] || $stdout)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(request_info(env))
    response
  end

  def request_info(env)
    <<-HEREDOC
    \n
      Request:    #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}
      Handler:    #{env['simpler.controller'].name.capitalize}Controller##{env['simpler.action']}
      Parameters: #{env['simpler.request.params']}
      Response:   #{env['simpler.response.status']} #{env['simpler.response.header']} #{env['simpler.template']}
    HEREDOC
  end
end
