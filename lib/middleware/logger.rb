require 'logger'
require 'byebug'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(logger_format(env, status, headers))

    [status, headers, body]
  end

  private

  def logger_format(env, status, headers)
    @logger.formatter = proc do
      <<-END
      Request: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}
      Handler: #{env['simpler.controller'].class.name}##{env['simpler.action']}
      Parameters: #{env['simpler.controller'].send(:params)}
      Response: #{status} [#{headers['Content-Type']}] #{env['simpler.view_path']}
      END
    end
  end

end