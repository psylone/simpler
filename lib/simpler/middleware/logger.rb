module Simpler
  module Middleware
    class Logger
      DEFAULT_FILE_NANE = 'log/app.log'.freeze

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        log(message(status, headers, env))
        [status, headers, body]
      end

      private

      def log(msg)
        File.open(Simpler.root.join(DEFAULT_FILE_NANE), 'a') do |file|
          file << "#{Time.now}\n"
          file << msg
        end
      end

      def message(status, headers, env)
        params = env['simpler.params'].merge(Rack::Request.new(env).params)

        "\tRequest: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}\n"\
        "\tHandler: #{env['simpler.controller'].class.name}##{env['simpler.action']}\n"\
        "\tParameters: #{params}\n"\
        "\tResponse: #{status} #{headers['Content-Type']} #{env['simpler.template.path']}\n"
      end
    end
  end
end
