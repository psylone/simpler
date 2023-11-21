require 'byebug'

class MyLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    response = @app.call(env)
    log = make_log(request)
    write_log(log)
    # debugger
    response
  end

  private

  def make_log(request)
    <<~LOG
    Request: #{request.request_method} #{request.path}
    Handler: #{controller}##{action}
    Parameters: #{params}
    Response: #{status} [#{content_type}] #{template}
    -
    LOG
  end

  def path
    @app.controller.request
  end

  def controller
    @app.controller.class.name
  end

  def action
    @app.action
  end

  def params
    @app.params
  end

  def status
    @app.controller.response.status
  end

  def content_type
    @app.controller.response.content_type
  end

  def template
    template = @app.controller.request.env['simpler.template']
    "#{template}.html.erb" if template
  end

  def write_log(log)
    File.open(Simpler.root.join('log/app.log'), 'a') do |f|
      f.write log
    end
  end
end
