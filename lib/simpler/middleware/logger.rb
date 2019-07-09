require 'pry'
require 'logger'

module Simpler
  class Logger

    def initialize(app)
      @logger = Logger.new(log_file)
      @app = app
    end
  
    def call(env)
      status, headers, body = @app.call(env)
      binding.pry
      [status, headers, body]
      
    end

    private

    def log_path
      'log/'
    end
  
    def log_file
      Simpler.root.join(log_path, "app.log")
    end
  
  
  end
end
