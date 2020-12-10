class NotFoundController < Simpler::Controller

  def not_found
    set_status 404
    set_default_headers
    @response.write('Page not found')
    @response.finish
  end
end
