require 'logger'

class CustomLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(message(env))
    response
  end

  def message(env)
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


  #def prepare_message(env)
  #  message = "\n"
  #  message << "Request #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n"
  #  message << "Handler #{env['simpler.controller'].name.capitalize}Controller##{env['simpler.action']}\n"
  #  message << "Parameters #{env['simpler.params']}\n"
  #  message << "Response #{env['simpler.response.status']} #{env['simpler.response.header']} #{env['simpler.render_params']}\n\n"
  #end
end
