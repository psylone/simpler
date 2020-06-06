class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: 'Plain text response'
    status 201
    headers['My-Header'] = 'test'
  end

  def create
    render plain: 'Plain text response'
  end

  def show

  end
end
