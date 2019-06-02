class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def text
    render plain: 'Plain text response'
  end

  def create

  end

end
