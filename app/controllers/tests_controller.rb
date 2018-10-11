class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render json: {test: 'test'}
    status 404
    headers['Some-Header'] = 'Title'
  end

  def create

  end

end
