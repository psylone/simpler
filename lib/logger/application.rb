# frozen_string_literal: true

module Logger
  # Rack application logger
  class Application
    LOG_FILE_NAME = 'log/app.log'

    def initialize(app)
      @app = app
      @dir_path = Logger.root.join(File.dirname(LOG_FILE_NAME))
      @file_path = Logger.root.join(LOG_FILE_NAME)

      Dir.mkdir(@dir_path) unless Dir.exist?(@dir_path)
    end

    def call(env)
      File.open(@file_path, 'at') do |log|
        write_log_before(log, env)

        status, headers, body = @app.call(env)

        write_log_after(log, env, status, headers)
        [status, headers, body]
      end
    end

    private

    def write_log_before(log, env)
      log.puts Time.now
      log.puts "Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
    end

    def write_log_after(log, env, status, headers)
      log.puts _log_for_handler(env)
      log.puts _log_for_parameters(env)
      log.puts _log_for_response(env, status, headers)
    end

    def _log_for_handler(env)
      if env['simpler.controller']
        "Handler: #{env['simpler.controller'].class.name}#"\
        "#{env['simpler.action']}"
      else
        'Handler: not found'
      end
    end

    def _log_for_parameters(env)
      return 'Parameters: empty' unless env['simpler.params']

      "Parameters: #{env['simpler.params']}"
    end

    def _log_for_response(env, status, headers)
      "Response: #{status} [#{headers['Content-Type']}]"\
      " #{env['simpler.template_path']}"
    end
  end
end
