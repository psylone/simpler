class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all

    # render html: "<h1>dddd</h1>"
     status 400
  end

  def create

  end

  def show
    @test = Test.find(id: params[:id])
  end

end
