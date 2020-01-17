require_relative 'simpler'
require_relative 'simpler/controller'
require 'logger'

  class RequestLogger
    def initialize(app)
      @app = app
      @env = nil
      @logger = nil
      @app.on(:make_response_event, &method(:log_request).to_proc)
    end

    def log_request(controller, action)
      @request = controller.request
      @controller = controller
      @action = action
      logger.info(request_data)
    end

    def call(env)
      response = @app.call(env)
      logger.info(response_data(@controller.response))
      # logger.close
      response
    end

    private

    attr_reader :request

    def logger
      @logger ||= new_logger
    end

    def new_logger
      log_file = Simpler.root.join('log/app.log')
      @logger = Logger.new(
        log_file,
        datetime_format: '%Y.%m.%d %H:%M:%S',
        formatter: proc do |_severity, _datetime, _progname, msg|
          "#{msg}"
        end
      )
    end

    def request_data
      "#{uri_info}\n#{handler_info}\n#{parameters_info}\n"
    end

    def uri_info
      method = request.request_method
      uri = request.env['REQUEST_URI']
      "Request: #{method} #{uri}"
    end

    def handler_info
      "Handler: #{@controller.name}\##{@action}"
    end

    def parameters_info
      "Parameters: #{request.params}"
    end

    def response_data(response)
      status_code = response.status.to_i
      reason = Rack::Utils::HTTP_STATUS_CODES[status_code]
      template = request.env['simpler.template']
      view_template = template.match(/\/\w+\/\w+\.html\.\w+/) if template.is_a?(String)
      "Response: #{status_code} #{reason} #{response.content_type} #{view_template}\n"
    end

  end
