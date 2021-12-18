class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 202
    render plain: 'tests/list'
    # render 'tests/list'
  end

  def create

  end

end
