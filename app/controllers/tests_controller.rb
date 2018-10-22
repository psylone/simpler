class TestsController < Simpler::Controller

  def index
    status 200
    @time = Time.now
  end

  def create

  end

  def show
    @test = Test[params[:id]]
    status 200
    header 'Content-Type' => 'text/html'
  end

end
