class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def show
    render plain: "params: #{params}"
  end

  def create; end
end
