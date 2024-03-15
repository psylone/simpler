class ErrorController < Simpler::Controller

  def no_page
    render plain: "Page not found"
    status 404
  end
end