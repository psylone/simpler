require 'logger'

class AppLogger

  def initialize(app, **options)


    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    @logger.info( "Request: #{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}")
    @app.call(env)



  end

end
