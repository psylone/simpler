class DefaultsController < Simpler::Controller

  def not_found
    status(404)
    @time = Time.now
  end


end
