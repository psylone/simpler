class TestsController < Simpler::Controller

  def index
    @time = Time.now
    # render plain: 'Plain text response', status: 404
    render 'tests/index', status: 201
  end

  def create

  end

  def show 
    @test_id = params[:id]
    @time = Time.now
    render 'tests/show'
    # render plain: 'Show', status: 201
  end 

end
