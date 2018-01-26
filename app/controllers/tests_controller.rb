class TestsController < Simpler::Controller

  def index
    render plain: "Index"
  end

  def create

  end

  def show
    @test = params
  end

end
