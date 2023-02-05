require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @env = env
    response = @app.call(env)
    request_log
    response_log(response)

    response
  end

  def request_log
    request_info
    handler_info
    params_info
  end

  def response_log(response)
    template_path = @env['simpler.template_path'] ? "#{@env['simpler.template_path']}.html.erb" : @env['simpler.render_handler']
    @logger.info "#{response[0]} [#{response[1]['Content-Type']}] #{template_path}"
  end

  private

  def request_info
    @logger.info "Request: #{@env['REQUEST_METHOD']} #{@env['REQUEST_URI']}"
  end

  def handler_info
    @logger.info "Handler: #{@env['simpler.controller'].class} # #{@env['simpler.action']}"
  end

  def params_info
    @logger.info "Parameters: #{@env['simpler.params']}"
  end
end
