class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: 'Plain text response'
    status 201
  end

  def create; end

  def show
    @test_id = params[:id]
  end
end
