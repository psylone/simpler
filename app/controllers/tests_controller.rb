class TestsController < Simpler::Controller

  def index
    set_header("Content-Type", "text/plain")
    render plain: "Hello World"
    #@time = Time.now
  end

  def create

  end

  def show
    render plain: "Show with params #{params[:id]}"
  end

end
