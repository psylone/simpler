class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create
  end

  def show
    @test = Test.find(id: params[:id])
  end

  def plain
    render plain: 'text'
    status 201
    headers 'Content-Type', 'text/html'
  end
end
