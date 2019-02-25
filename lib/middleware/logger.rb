require 'logger'

class SimplerLogger

  def initialize(app,  **options )
    @app = app
    @logger = Logger.new(options[:logdev]) || STDOUT
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(txt(status, headers, env))

    [status, headers, response]
  end

  private

  def txt(status, headers, env)
"\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
Handler: #{env['simpler.controller'].class}# #{env['simpler.action']}
Parameters: #{env['simpler.params']}
Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template_path']}
"

  end
end
