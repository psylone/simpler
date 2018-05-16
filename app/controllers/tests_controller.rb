class TestsController < Simpler::Controller
  def index
    @time = Time.now
    @tests = Test.all
  end

  def create
    render plain: "Plain text response"
  end

  def show
    @test = Test.first(id: params[:id]).first
  end
end
