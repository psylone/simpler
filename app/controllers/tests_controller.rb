class TestsController < Simpler::Controller
  def index
    @time = Time.now
    # render plain: "Plain text response!!!"
    # headers['Content-Type'] = 'text/html'
  end

  def create

  end

  def show
    @params = params[:id]
  end
end
