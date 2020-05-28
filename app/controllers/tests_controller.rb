class TestsController < Simpler::Controller

  def index
    @time = Time.now
    params[:test] = 'success'
  end

  def create

  end

  def show
  end

end
