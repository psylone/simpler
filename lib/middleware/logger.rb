require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])    
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env) 
    @logger.info(logger_format(env, status, headers))
    [status, headers, body]  
  end

  def logger_format(env, status, headers)
    @logger.formatter = proc do
  <<-EOS
  Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
  Handler: #{env['simpler.controller'].class}##{env['simpler.action']}
  Parameters: #{env['simpler.controller'].send :params }
  Response: #{status} [#{headers['Content-Type']}] #{env['simpler.view_path']}
  EOS
    end
  end

end