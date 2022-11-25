class TestsController < Simpler::Controller
  def index
    @time = Time.now
    @tests = Test.all
    headers["Content-Type"] = "text/html"
    status 201
  end

  def create
  end

  def show
    @test = Test.where(id: params[:id]).first
  end
end
