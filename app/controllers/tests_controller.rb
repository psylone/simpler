class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create
    status 201
    headers['Content-Type-X'] = 'test'
    render plain: "Plain text response\n"
  end

end
