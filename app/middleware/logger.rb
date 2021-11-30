require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    app = @app.call(env)
    @logger.info(info_log(env))
    app
  end

  def info_log(env)
    "\n{\nRequest: #{env['REQUEST_METHOD']} #{env["REQUEST_PATH"]}\n" \
      "Handler: #{env['simpler.controller'].class.name + '#' + env['simpler.action']}\n" \
      "Parameters: #{env['simpler.controller'].request.params}\n" \
      "Response: #{env['simpler.controller'].response}\n}"
  end

end
