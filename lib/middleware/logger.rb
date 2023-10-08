require 'logger'

class LoggerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    log = build_log(env, status, headers)
    logger = Logger.new('log/app.log')
    logger.info { "\n#{log}" }
    logger.close

    [status, headers, response]
  end

  private

  def build_log(env, status, headers)
    request_method = env['REQUEST_METHOD']
    request_path = env['REQUEST_PATH']
    controller = env['simpler.controller']
    action = env['simpler.action']
    params = env['simpler.params']

    "Request: #{request_method} #{request_path}\n" \
    "Handler: #{controller ? "#{controller.class}##{action}" : 'none'}\n" \
    "Parameters: #{params&.any? ? params : 'none'}\n" \
    "Response: #{status} [#{headers['Content-Type']}] #{template_name(action)}\n"
  end

  def template_name(action)
    action ? "#{controller_name(action)}/#{action}.html.erb" : 'none'
  end

  def controller_name(action)
    action.split('/')[1]
  end
end
