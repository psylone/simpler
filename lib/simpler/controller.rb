module Simpler
  class Controller

    def initialize(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response
      [
        200,
        { 'Content-Type' => 'text/plain' },
        ["Simpler framework at work!\n"]
      ]
    end

  end
end
