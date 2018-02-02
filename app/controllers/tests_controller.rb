class TestsController < Simpler::Controller

  def index
    @tests = Test.all
  end

  def create

  end

  def show
    @test = set_params
  end

end
