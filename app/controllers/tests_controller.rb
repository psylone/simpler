class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @test_id = params[:id]
  end

  def create
    status 201
    headers['Content-Type-X'] = 'test'
    render plain: "Plain text response\n"
  end

  def show
    @test_id = params[:id]
  end

end
