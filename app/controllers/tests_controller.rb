class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: 'tests/plain'	    headers['Content-Type'] = 'text/plain'
    # render plain: 'tests/plain'
  end

  def create

  end

end
