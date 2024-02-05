require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || $stdout)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(message(env, status, headers))
    [status, headers, body]
  end

  def message(env, status, headers)

    controller = env['simpler.controller']

    if controller
      <<~LOGGER

      --------------------------------------------------------------
        Request:    #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
        Handler:    #{env['simpler.controller'].class}##{env['simpler.action']}
        Parameters: #{env['simpler.params']}
        Response:   #{status} [#{headers['Content-Type']}] #{env['simpler.template_path']}

      LOGGER
    else
      <<~LOGGER

      --------------------------------------------------------------
        Request:    #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
        Response:   #{}

      LOGGER
    end
  end
end
