require 'logger'

class AppLogger
  def initialize(app, **options)
    @app = app
    @logger = Logger.new(options[:logPath] || STDOUT)
  end

  def call(env)
    response = @app.call(env)
    @logger.info(generate_log_entry(env, response))
    response
  end

  private

  def generate_log_entry(env, response)
    "\n".concat(request_info(env),
                handler_info(env),
                params_info(env),
                response_info(env, response)
                )         
  end

  def request_info(env)
    "Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']} \n"
  end

  def handler_info(env)
    "Handler: #{env['simpler.controller'].class}##{env['simpler.action'].to_s} \n"
  end

  def params_info(env)
    "Parameters: #{env['QUERY_STRING']} \n"
  end

  def response_info(env, response)
    "Response: #{response[0]} #{status_name(response)} [#{response[1]['Content-type']}] #{env['simpler.template']}"
  end

  def status_name(response)
    Rack::Utils::HTTP_STATUS_CODES[response[0]]
  end

end
