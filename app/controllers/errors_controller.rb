class ErrorsController < Simpler::Controller

  def error_404
    status 404
    @url = @request.path
  end

end
