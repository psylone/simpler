require 'logger'

class AppLogger

  def initialize(app, **options)
    @app = app
    @logger = Logger.new(options[:logdev] || STDOUT)
  end


  def call(env)
    recap(env)
    @app.call(env).tap do |response|
      status, headers, body = *response
      @logger.info "Response: #{status}, #{headers}, #{env['simpler.template_path']}"
    end
  end

  def recap(env)
    method = env['REQUEST_METHOD']
    path = env['REQUEST_URI']
    route = @app.router.route
    controller = route.controller
    action = route.action
    parametrs = env['QUERY_STRING']

    @logger.info "Request: #{method} #{path}"
    @logger.info "Handler: #{controller}##{action}"
    @logger.info "Parametrs: #{parametrs}"

  end
end
