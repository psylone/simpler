class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def text
    render plain: 'Plain text response'
  end

  def create
    status 201
    render plain: 'Created'
  end

end
