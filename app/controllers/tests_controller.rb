class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain:'Hello'
  end

  def create

  end

end
