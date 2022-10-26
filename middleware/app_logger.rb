require 'logger'

class AppLogger
  def initialize(app, **options)
    @app = app
    @logger = Logger.new(options[:logdev] || STDOUT)
    @call_result = nil
    clear_info
  end

  def call(env)
    @call_result = @app.call(env)

    add_request_line(env)
    add_handler_line(env)
    add_parametrs_line(env)
    add_response_line(env)

    @logger.info(@info)
    clear_info

    @call_result
  end

  private

  def add_request_line(env)
    @info += "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n"
  end

  def add_handler_line(env)
    @info += "Handler: #{env['simpler.controller'].class.name}##{env['simpler.controller'].name}\n"
  end

  def add_parametrs_line(env)
    @info += "Parametrs: #{env['simpler.route_params']}\n"
  end

  def add_response_line(env)
    status, headers = @call_result
    template = env['simpler.template_path'] ? " #{env['simpler.template_path']}" : ""

    @info += "Response: #{status} #{Rack::Utils::HTTP_STATUS_CODES.fetch(status)} [#{headers['Content-Type']}]#{template}\n"
  end

  def clear_info
    @info = "\n"
  end
end
