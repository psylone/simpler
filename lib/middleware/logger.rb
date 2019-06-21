require 'logger'

class AppLogger

  def initialize(app, **options)

    create_log_file(options[:logdev])

    @logger = Logger.new(options[:logdev] || STDOUT)

    @logger.formatter = proc do |severity, datetime, progname, msg|
      progname = 'Simpler'
      "[#{datetime}] #{progname} #{severity}: #{msg}\n"
    end

    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(body(env, *response))
    response
  end

  def body(env, status, headers, rack)
    body = [
            "",
            "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}",
            "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}",
            "Parameters: #{env['simpler.params']}",
            "Response: #{status} [#{headers["Content-Type"]}] #{headers['template']}"
            ]

    body.join("\n\t")
  end

  private

  def create_log_file(log)
    unless File.exist?(log)
      dir = File.dirname(log)
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      FileUtils.touch(log)
    end
  end

end
