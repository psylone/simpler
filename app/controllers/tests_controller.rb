class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create
  end

  def show
    @test = Test.find(id: params[:id])
  end

end
