class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create
    status 201
    render plain: "Plain text response\n"
  end

end
