require 'logger'

class AppLogger

  #LOGFILE = Simpler.root.join('log/app.log')

  def initialize(app)
    @app = app
    @logger = Logger.new(Simpler.root.join('log/app.log'))
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(write_log(env, status, headers))
    [status, headers, body]
  end

  private

  def write_log(env, status, headers)
    {
        Request: "#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}",
        Handler: "#{env['simpler.controller'].class}##{env['simpler.action']}",
        Parameters: env['simpler.params'],
        Response: "#{status} [#{headers['Content-Type']}] #{env['simpler.template_path_view']}"
    }
  end

end