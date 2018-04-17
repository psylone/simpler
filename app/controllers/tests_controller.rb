class TestsController < Simpler::Controller

  def index
    # render plain: "#{@request.params}"
  end

  def create

  end

  def show
    render plain: "#{params}"
  end

end
