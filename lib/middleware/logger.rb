require 'fileutils'

class AppLogger

  LOGFILE_PATH = 'log/app.log'.freeze

  def initialize(app)
    @app = app
    initialize_logfile!
  end

  def call(env)
    status, headers, response = @app.call(env)
    log = message(env, status, headers)
    File.open(LOGFILE_PATH, 'a+') { |file| file.write(log) }
    [status, headers, response]
  end

  private

  def message(env, status, headers)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
    "Parameters: #{env['simpler.params']}\n" \
    "Response: #{status} #{headers['Content-Type']} #{env['simpler.render_view']}\n" \
  end

  def initialize_logfile!
    directory_name = File.dirname(LOGFILE_PATH)

    FileUtils.mkdir_p(directory_name) unless File.directory?(directory_name)
  end

end
