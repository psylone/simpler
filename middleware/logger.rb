require 'logger'

class AppLogger
  def initialize(app)
    @logger = Logger.new(File.expand_path('../log/app.log', __dir__))
    @app = app
  end

  def call(env)

    @response = @app.call(env)

    @logger.info(log_message(env))
    @response
  end

  private

  def log_message(env)
    <<~LOG_INFO
      Request: "#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}?#{env['QUERY_STRING']}"
      Handler: "#{env['simpler.controller'].name}##{env['simpler.action']}"
      Parameters: "#{env['simpler.params']}"
      Response: "#{@response[0]} [#{@response[1]['content-type']}] #{env['simpler.template_path']}"
    LOG_INFO
  end
end
