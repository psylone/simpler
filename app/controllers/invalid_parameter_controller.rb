class InvalidParameterController < Simpler::Controller
  def invalid
    status 404
    render plain: "Parameter must be integer"
  end
end
