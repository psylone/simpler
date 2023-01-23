class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render 'tests/list'
    status 201
    set_header 'Content-type', 'text/plain'
  end

  def create

  end

end
