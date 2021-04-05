require 'logger'
require 'pry'
class SimplerLogger
	def initialize(app, **options)
		@logger = Logger.new(options[:logdev] || STDOUT)
		@app = app 
	end

	def call(env)
		response =  @app.call(env)
		@logger.info(response[1]['Log'])
		response
	end

end