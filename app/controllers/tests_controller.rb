class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create

  end

  def list
    render plain: 'Plain text response'
    status 201
  end

end
