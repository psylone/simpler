class TestsController < Simpler::Controller

  def index
    @time = params
  end

  def create

  end

  def show
    @test = params
  end

end
