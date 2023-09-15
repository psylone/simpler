class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: 'hello world'
  end

  def create; end

  def show
    p params[:id]
  end
end
