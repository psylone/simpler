require 'logger'

 module Simpler
   class AppLogger
     def initialize(app, **options)
       @logger = Logger.new(options[:file_path] || $stdout)
       @app = app
     end

     def call(env)
       @status, @header, @body = @app.call(env)
       @request = Rack::Request.new(env)

       @logger.info(build_log)

       Rack::Response.new(@body, @status, @header).finish
     end

     private

     def build_log
       {
         Request: "#{@request.request_method} #{@request.fullpath}",
         Handler: "#{controller}##{action}",
         Parameters: @request.params.to_s,
         Response: "#{status_string} [#{content_type}] #{view}"
       }.to_s
     end

     def status_string
       Rack::Utils::HTTP_STATUS_CODES[@status]
     end

     def content_type
       @header['Content-Type']
     end

     def controller
       @header['X-Simpler-Controller']
     end

     def action
       @header['X-Simpler-Action']
     end

     def view
       @header['X-Simpler-View']
     end
   end
 end