require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(process_log(env, status, headers))
    [status, headers, response]
  end

  private

  def process_log(env, status, headers)
    @logger.formatter = proc do
      "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n"\
      "Handler: #{env['simpler.controller'].name.capitalize}Controller##{env['simpler.action']}\n"\
      "Parameters: #{env['simpler.controller'].send :params}\n"\
      "Response: #{status} #{headers['Content-Type']} #{env['simpler.template_path']}\n"
    end
  end

end
