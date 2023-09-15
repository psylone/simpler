require 'logger'

module CustomLogger
  class CustomLogger
    def initialize
      @logger = Logger.new('log/app.log')
      format_logger
    end

    def request_msg(env, body)
      handler = "#{body[:controller]}\##{body[:action]}"
      parameters = env['QUERY_STRING'].split('&')
                                      .map { |pair| pair.split('=') }
                                      .to_h

      msg = "
Request: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}
Handler: #{handler}
Parameters: #{parameters}"

      @logger.info(msg)
    end

    # Response: 200 OK [text/html] tests/index.html.erb
    def response_msg(data)
      status = data[:status]
      content_type = data[:content_type]
      path = data[:path]
      msg = "
Response: #{status} [#{content_type}] #{path}\n"
      @logger.info(msg)
    end

    private

    def format_logger
      @logger.formatter = proc do |_severity, _datetime, _progname, msg|
        msg
      end
    end
  end
end
