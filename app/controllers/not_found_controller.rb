class NotFoundController < Simpler::Controller
  def not_found
    status 404
    render plain: "Not Found"
  end
end
