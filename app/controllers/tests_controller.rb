class TestsController < Simpler::Controller

  def index
    @time = params
  end

  def create

  end

  def show
    @params = params
  end

end
