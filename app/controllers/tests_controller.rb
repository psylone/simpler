class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render 'index'
  end

  def create
    render text: 'Create test'
  end

  def show
    @test = request_params
    render 'show'
  end

end
