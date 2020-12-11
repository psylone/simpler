class TestsController < Simpler::Controller

  def index
    render 'tests/index'
    # render plain: "Simpler Plain text responce "

    @time = Time.now
  end

  def create

  end

  def show
    @params = route_params
    render 'tests/show'
  end

end
