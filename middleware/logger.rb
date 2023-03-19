require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    response = @app.call(env)

    request(env)
    handler(env)
    parameters(env)
    response(env, response)

    response
  end

  private

  def request(env)
    @logger.info("Request: #{env['REQUEST_METHOD']}/ #{env['REQUEST_URI']}")
  end

  def handler(env)
    if env['simpler.controller']
      @logger.info("Handler: #{env['simpler.controller'].class.name}##{env['simpler.action']}")
    else
      @logger.info('Controller not found')
    end
  end

  def parameters(env)
    if env['simpler.controller']
      @logger.info("Parameters: #{env['simpler.controller'].send('params')}")
    else
      @logger.info("Parameters: {#{env['QUERY_STRING']}}")
    end
  end

  def response(env, response)
    status, headers, body = response
    @logger.info("Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template_path']}")
  end
end
