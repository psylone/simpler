require_relative 'view'

module Simpler
  class Controller
    RENDER_FORMATS = [:body, :plain, :html]

    attr_reader :name, :request, :response, :format

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

      send(action)
      write_response
      @response.finish
    end

    private

    def not_found
      status = 404
      headers = {}
      body = ["Nothing found"]
      self
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] ||= 'text/html'
    end

    def write_response
      body = render_body
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def set_rendered_content_type(format)
      if format && !@response['Content-Type']
        case format
         #   when :html then @response['Content-Type'] = "text/html"
          when :plain then @response['Content-Type'] = "text/plain"
        else
          # если формат не указан и контент тайп не указан - по дефолту устанавливаем
          # или есть формат :html
          @response['Content-Type'] = "text/html"
        end
        p @response['Content-Type']
      end
    end

    def params
      @request.params
    end

    # render plain: "404 Not Found", status: 404
    #def render(template)
    def render(options)
      # если не просто render :edit
     p options.is_a?(Hash)
      if options.is_a?(Hash)

        content_type, status = options.values_at(:content_type, :status)
        @response['Content-Type'] = content_type if content_type
        @response.status = status if status
      
        format = RENDER_FORMATS.find { |f| options.keys[0] == f }


      # если надо рендерить не страницу, а текст render :plain/:html/:body "smth" 

        @format = format.nil? ? :html : format
        set_rendered_content_type(@format)
        @request.env['simpler.template'] = options[@format]
   
      #  @request.env['simpler.template'] = options
      end
        p @request.env['simpler.template']
     # @request.env['simpler.template'] = options.first
      # unless format
      #   @request.env['simpler.template'] = options.first
      #   return
      # end
      
     # @response['Formated-Content'] = options[format]



    end



  end
end
