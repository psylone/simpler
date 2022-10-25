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
    @logger.info "Request: #{@env['REQUEST_METHOD']} #{@env['REQUEST_URI']}"
    @logger.info "Handler: #{@env['simpler.controller'].class} # #{@env['simpler.action']}"
    @logger.info "Parameters: #{@env['simpler.params']}"
  end

  def response_log(response)
    template_path = @env['simpler.template_path'] ? "#{@env['simpler.template_path']}.html.erb" : ''
    @logger.info "#{response[0]} [#{response[1]['Content-Type']}] #{template_path}"
  end

end
