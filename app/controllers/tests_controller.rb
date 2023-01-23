class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render 'tests/list'
  end

  def create

  end

end
