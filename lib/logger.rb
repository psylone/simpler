require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(prepare_message(env))
    response
  end

  private

  def prepare_message(env)
    message = "\n"
    message << "Request #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n"
    # message << "Handler #{env['simpler.controller'].name.capitalize}Controller##{env['simpler.action']}\n"
    message << "Parameters #{env['simpler.params']}\n"
    message << "Response #{env['simpler.response.status']} #{env['simpler.response.header']} #{env['simpler.render_params']}\n\n"
  end

end
