
require 'logger'
require 'fileutils'

class AppLogger

  def initialize(app, **options)
    if options[:logdev]
      dirname = File.dirname(options[:logdev])
      FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
    end

    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    log(env, status, headers)
    [status, headers, body]
  end

  private

  def log(env, status, headers)
    log = %(
      Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}
      Handler: #{env['simpler.controller'].name.capitalize}Controller##{env['simpler.action']}
      Parameters: #{env['simpler.controller'].params}
      Response: #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]} [#{headers['Content-Type']}] #{env['simpler.template_path']}
    )

    @logger.info(log)
  end

end