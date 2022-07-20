require_relative 'logger'

class App
  def initialize # - сюда нужно передать app, не понял как это сделать
    @logger = Logger.new
  end

  def call(env)
    req = Rack::Request.new(env)
    status, headers, response = req
    @logger.log(status, env)

    [status, headers, response]
  end
end
