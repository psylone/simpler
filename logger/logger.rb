require 'logger'

class Applogger
  
  def initialize(app)
    file = File.open(File.expand_path(File.dirname(__dir__)) + '/log/app.log', File::WRONLY | File::APPEND | File::CREAT)
    @logger = Logger.new(file)
    @app = app
  end

  def call(env)
    @logger.info('request'){ env['REQUEST_METHOD'] + env['PATH_INFO']}
    responce = @app.call(env) 

    @logger.info('Handler'){env['simpler.controllername']}
    @logger.info('Parameter'){env['QUERY_STRING'] + '#' + env['simpler.action']}
    @logger.info('Responce'){responce[0].to_s + ' ' + Rack::Utils::HTTP_STATUS_CODES[responce[0]] + ' [' + responce[1]['Content-Type'] + '] ' + responce[2][0]}
    responce
  end

end