class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create
    render plain: "Plain text response\n"
  end

end
