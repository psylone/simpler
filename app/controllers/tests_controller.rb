class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
    headers['X-Header'] = 'true'
  end

  def create

  end

end
