require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    controller = @app.controller
    template = controller.request.env['simpler.template']
    log = "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" +
        +"Handler: #{controller.name.capitalize}Controller##{@app.action}\n" +
        +"Parameters: #{controller.request.params}\n" +
        +"Response: #{controller.response.status} #{'OK' if controller.response.ok?} " +
        +"[#{headers['Content-Type']}] " +
        +"#{(controller.name + '/' + template.to_s + '.html.erb') if template}"
    @logger.info(log)
    [status, headers, body]
  end
end