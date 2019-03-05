require 'logger'

class SimplerLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
   @logger.info("Request: #{env['REQUEST_METHOD']}#{env['REQUEST_URI']}")
   @logger.info("Handler: #{}##{}")
   @logger.info("Parameters: #{}")
   @logger.info("Response: #{}")
   @app.call(env)
 end

end
