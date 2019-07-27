require 'logger'

module Simpler
  module Middleware    
    class AppLogger

      def initialize(app, **options)
        @logger = Logger.new(options[:logdev] || STDOUT)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        log_request(env)
        log_response(env, status, headers)
        [status, headers, body]
      end

      private

      def log_request(env)
        @logger.info("Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}")
        @logger.info("Handler: #{env['simpler.controller'].class.name}##{env['simpler.action']}")
        @logger.info("Parameters: #{env['simpler.controller'].params}")
      end

      def log_response(env, status, headers)
        @logger.info("Response: #{status} #{headers['Content-Type']} #{env['simpler.template.path']}")
      end

    end
  end
end
