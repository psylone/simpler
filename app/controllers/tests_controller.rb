class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render 'tests/list'
    status 201
  end

  def create

  end

end
