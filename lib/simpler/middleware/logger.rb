require 'logger'

module Simpler
  class AppLogger

    def initialize(app)
      @log = Logger.new(log_file)
      @app = app
    end
  
    def call(env)
      status, headers, body = @app.call(env)
      add_log(env)
      [status, headers, body]      
    end

    private

    def log_path
      'log/'
    end
  
    def log_file
      Simpler.root.join(log_path, "app.log")
    end
  
    def add_log(env)
      controller = env["simpler.controller"]
      response = if controller == nil
                  'No'
                 else
                  controller.response
                 end
      action = env["simpler.action"]
      @log.info add_request(env["REQUEST_METHOD"], env["PATH_INFO"])
      @log.info add_handler(controller, action)
      if controller == nil
        @log.info add_parameters("No")
      else
        @log.info add_parameters(controller.request.params)
      end
      @log.info add_response(response, env["simpler.template"], controller, action)
    end

    def add_request(method, path)
      "Request: #{method} #{path}"
    end

    def add_handler(controller, action)
      if controller == nil
        "Handler: No"
      else
        "Handler: #{controller.name.capitalize}Controller#{action}"
      end
    end

    def add_parameters(params)
      "Parameters: #{params}"
    end

    def add_response(response, template, controller, action)
      if response == 'No'
        "Response: #{response}"  
      else
        status = response.status
        header = response.headers['Content-Type']
        path = if template == nil
                "#{controller.name}/#{action}.html.erb"
              else
                ''
              end
        "Response: #{status} #{header} #{path}"
      end
    end
  
  end
  
end
