class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create

  end

  def plain
    render plain: "test"
  end

  def show
    render plain: "show #{params[:id]}"
  end
end
