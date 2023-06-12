require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(log_message(env))
    response
  end

  private

  def log_message(env)
    controller = env['simpler.controller']

    if controller
      <<~LOGGER
        ********************************************************
        Request:    #{env['REQUEST_METHOD']} #{env['PATH_INFO']}
        Handler:    #{controller.name.capitalize}Controller##{env['simpler.action']}
        Parameters: #{env['simpler.params']}
        Response:   #{env['simpler.response.status']} [#{env['simpler.response.header']}] #{env['simpler.template']}
      LOGGER
    else
      <<~LOGGER
        Request:    #{env['REQUEST_METHOD']} #{env['PATH_INFO']}
        Response:   #{}
      LOGGER
    end
  end
end
