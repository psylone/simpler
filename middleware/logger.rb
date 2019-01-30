require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(request_info(env))
    @logger.info(response_info(env, status, headers))

    [status, headers, body]
  end

  private

  def request_info(env)
    request_info = "\n REQUEST INFO \n"
    request_info << "Request Method #{env['REQUEST_METHOD']}\n"
    request_info << "Path Info: #{env['PATH_INFO']}\n"
    request_info << "Query #{env['QUERY_STRING']}\n" unless env['QUERY_STRING'].empty?

    request_info << "Controller #{env['simpler.controller'].name.capitalize} \n" if env['simpler.controller']
    request_info << "#{env['simpler.controller'].params}\n" unless env['simpler.controller'].params.empty?
    request_info << "Action #{env['simpler.action']}\n" if env['simpler.action']
  end

  def response_info(env, status, headers)
    response_info = "\n RESPONSE INFO \n"
    response_info << "Status #{status}\n"
    response_info << "Content-Type #{headers['Content-Type']}\n"
    response_info << "View #{env['simpler.template_path']}\n" if env['simpler.template_path']
  end
end
