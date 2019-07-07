class ExceptionsController < Simpler::Controller

  def not_found
    status 404
    render 'exceptions/404'
  end
end
