class TestsController < Simpler::Controller
  def index
    @tests = Test.all
    # render plain: 'Some text here'
    # status 200
  end

  def show
    @test = Test.find(id: params[:id])
  end
end
