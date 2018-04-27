class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
    render plain: "Plain text response"
  end

  def create

  end

end
