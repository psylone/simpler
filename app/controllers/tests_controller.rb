class TestsController < Simpler::Controller
  def index
    @time = Time.now
  end

  def show
    @params = params[:id]
  end
end
