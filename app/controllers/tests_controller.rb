class TestsController < Simpler::Controller
  def index
    @time = Time.now
    @tests = Test.all
    status 500

  end

  def create

    render plain: "Plain text response \n"

    header['Content-Type'] = 'text/plain'
  end

  def show
    @test = Test.first(id: params[:id])
  end
end
