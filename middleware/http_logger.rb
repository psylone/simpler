# This middleware writes formatted web-server output

class HttpLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    File.open(Simpler.root.join('log/simpler.log'), 'a+') do |f|
      f << "Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}#{env['QUERY_STRING']}\n"
      f << "Handler: #{env['simpler.controller']&.class&.name}\##{env['simpler.action']}\n"
      f << "Parameters: #{env['simpler.controller']&.request&.params}\n"
      f << "Response: #{status} #{env['simpler.response_type']} #{env['simpler.template']}\n"
      f << "----------------------------\n"
    end
    [status, headers, body]
  end
end
