class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create

  end

  def show
    @test = Test.where(id: params[:id]).first
    status 404 unless @test
  end

end
