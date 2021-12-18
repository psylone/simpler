class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 202
    headers['Content-Type'] = 'text/plain'
    render plain: 'tests/list'
    # render 'tests/list'
  end

  def create

  end

end
