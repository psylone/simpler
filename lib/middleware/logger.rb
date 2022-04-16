require 'logger'

class AppLogger

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
    template = ->(action) { action ? "#{get_controller_name(env['REQUEST_PATH'])}/#{action}.html.erb" : "none" }
    handler = ->(controller) { controller ? "#{controller.class}##{env['simpler.action']}" : "none" }
    parameters = ->(params) { params&.any? ? params : "none" }
    record = ["Request: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}\n",
              "Handler: #{handler.call(env['simpler.controller'])}\n",
              "Parameters: #{parameters.call(env['simpler.params'])}\n",
              "Response: #{status} [#{headers['Content-Type']}] #{template.call(env['simpler.action'])}\n"]

    "#{record.join('')}"
  end

  def get_controller_name(path)
    elements = path.split('/')
    elements.delete('')
    elements.first
  end

end