require_relative 'view'

module Simpler
  class Controller
    RENDER_FORMATS = [:body, :plain, :html]

    attr_reader :name, :request, :response
    attr_accessor :status, :headers, :content

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)



            # [
      #   200,
      #   { 'Content-Type' => 'text/plain', 
      #     'X-Simpler-Controller' => self.class.name,
      #     'X-Simpler-Action' => action },
      #   ["Simpler framework in action!\n"]
      # ]



      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action



      set_default_headers
      #self.status = 200
     #self.headers = {"Content-Type" => "text/html"}
      send(action)
      write_response
   #    self.content = []
      @response.finish



#      @request.env[]
      # @request.env['simpler.format'] = 
      # @request.env['simpler.status'] =

#       render html: 'Hello'
# response.body # => "Hello"
# response.content_type # => "text/html"

     # set_default_headers
      # send(action)
      # write_response

      # @response.finish
    end

    private

    # def not_found
    #   status = 404
    #   headers = {}
    #   body = ["Nothing found"]
    #   self
    # end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    # def set_default_status
    #   @response['Status'] = 200
    # end

    def write_response
   #   set_default_status
    #  status = 200
  #    headers = {"Content-Type" => "text/html"}
      body = render_body
      @response.write(body)
    end

    def render_body 




    #  if       @response['Content-Type'] = 'text/plain'
    p @response['Format']

    #  View.new(@request.env).render(binding, format)
   if @response['Format'] == :html
     View.new(@request.env).render(binding) 

else
      [
         @response.status,
        { 'Content-Type' => @response['Content-Type'], 
      #    'X-Simpler-Controller' => self.class.name,
     #     'X-Simpler-Action' => action }, 
        },
        ["Simpler framework in action!\n"]
      ]  

end

    end

    def params
      @request.params
    end


    # render plain: "404 Not Found", status: 404
    #def render(template)
    def render(options = {})

      content_type, status = options.values_at(:content_type, :status)
      format = RENDER_FORMATS.select {|f| options.keys[0] == f }
      @response['Format'] = format.nil? ? :html : format
      @response['Content-Type'] = content_type if content_type
      @response.status = status if status




 #     format = :html : RENDER_FORMATS.select {|f| options.keys[0] == f }
     # template = options[1]
      #this_format = :html || RENDER_FORMATS.select { |f| format == f }


    #   status, content_type, location = options.values_at(:status, :content_type, :location)

      #   self.status = status if status
      #   self.content_type = content_type if content_type


      # if options[:status]
      #    @response.status = options[:status]
      #    self.status = options[:status]
      #    @response['Status'] = options[:status]
      #    @response.status =  300
      # p  Rack::Utils.status_code(options[:status])
      #  end




              #тут тернарный
      # if format
      #   @response['Format'] = format
      # else
      #   @response['Format'] = :html
      # end

 



  

     #  @response['Status'] = status if status
       
      
     # @request.env['simpler.template'] = template
 


    end

    # def render(*args)


    # end



      #     def _render_in_priorities(options)
      #   RENDER_FORMATS_IN_PRIORITY.each do |format|
      #     return options[format] if options.key?(format)
      #   end

      #   nil
      # end

      # def _set_html_content_type
      #   self.content_type = Mime[:html].to_s
      # end

      # def _set_rendered_content_type(format)
      #   if format && !response.content_type
      #     self.content_type = format.to_s
      #   end
      # end

    # def record_not_found
    #   render plain: "404 Not Found", status: 404
    # end


  # Normalize both text and status options.
      # def _normalize_options(options)
      #   _normalize_text(options)

      #   if options[:html]
      #     options[:html] = ERB::Util.html_escape(options[:html])
      #   end

      #   if options[:status]
      #     options[:status] = Rack::Utils.status_code(options[:status])
      #   end

      #   super
      # end


      # Process controller specific options, as status, content-type and location.
      # def _process_options(options)
      #   status, content_type, location = options.values_at(:status, :content_type, :location)

      #   self.status = status if status
      #   self.content_type = content_type if content_type
      #   headers["Location"] = url_for(location) if location

      #   super
      # end

    #render(options = nil, extra_options = {}, &block) protected

    # Renders the clear text "Explosion!"  with status code 500
  #render :text => "Explosion!", :status => 500

  end
end
