require_relative '../controller'

module Simpler
  class PageNotFoundController < Controller
    def initialize(env)
      super
      @response.status = 404
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'] = params
      @request.env['simpler.template'] = '404'

      set_default_headers
      write_response

      @response.finish
    end

  end
end
