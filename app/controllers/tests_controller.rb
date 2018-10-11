class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render json: {test: 'test'}
  end

  def create

  end

end
