class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render 'tests/index'
    status 201
    headers['Content-Type'] = 'text/plain'
  end

  def create

  end

  def show 
    @test_id = params[:id]
    @time = Time.now
    render 'tests/show'
  end 

end
