class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create

  end

  def show
    id = params[:id].to_i
    @test = Test.all.find { |t| t[:id] == id }
  end

end
