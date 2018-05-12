class TestsController < Simpler::Controller

  def index
    #@time = Time.now
  end

  def create
    @test = params
  end

end
