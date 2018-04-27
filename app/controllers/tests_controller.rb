class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
    headers['My-Header'] = 'test'
    render plain: "Plain text response"
  end

  def create

  end

  def show
    @parameters = params
  end

end
