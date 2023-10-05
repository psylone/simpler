require 'logger'

class AppLogger
  
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STROUT)
    @app = app
  end

  def call(env)
    request_line = "\nRequest: #{env["REQUEST_METHOD"]} "
    request_line << env["PATH_INFO"]
    request_line << "/?#{env["QUERY_STRING"]}" unless env["QUERY_STRING"].empty?
    @logger.info request_line
    
    status, headers, body = @app.call(env)
    
    if env['simpler.controller']
      @logger.info "\nParameters: #{env['simpler.controller'].params}"
    end
    @logger.info "\nHandler: #{env['simpler.handler']}"

    response_line = "\nResponse: #{status} "
    response_line << "[#{headers['Content-Type']}]"
    response_line << " #{env['simpler.template']}"
    @logger.info response_line
    
    [status, headers, body]
  end

end
