require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    request_info(env)

    app = @app.call(env)

    handler_info(env)
    params_info(env)
    response_info(env)
    
    @logger.info('------------')

    app
  end

  private

  # Request: GET /tests?category=Backend
  def request_info(env)
    log_str = 'Request: '
    log_str += env['REQUEST_METHOD']
    log_str += ' '
    log_str += env['REQUEST_URI']
    @logger.info(log_str)
  end

  # Handler: TestsController#index
  def handler_info(env)
    log_str = 'Handler:'
    log_str += " #{env['simpler.controller'].class}" if env.has_key?('simpler.controller')
    log_str += "##{env['simpler.action']}" if env.has_key?('simpler.action')
    @logger.info(log_str)
  end

  # Parameters: {'category' => 'Backend'}
  def params_info(env)
    log_str = 'Parameters: '
    request = Rack::Request.new(env)
    log_str += request.params.inspect
    @logger.info(log_str)
  end

  # Response: 200 OK [text/html] tests/index.html.erb
  def response_info(env)
    if env.has_key?('simpler.controller')
      log_str = 'Response:'
      response = env['simpler.controller'].response
      
      status = response.status
      status_descr = Rack::Utils::HTTP_STATUS_CODES[status]

      log_str += " #{status} #{status_descr}"
      log_str += " [#{response.get_header('Content-Type')}]" if response.has_header?('Content-Type')

      log_str += " #{env['simpler.template_file']}" if env.has_key?('simpler.template_file')

      @logger.info(log_str)
    end
  end

end