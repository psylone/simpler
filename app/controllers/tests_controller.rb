class TestsController < Simpler::Controller

  def index
    headers['Content-Type'] = 'text/plain'
  end

  def create

  end

  def show
    @test = set_params
  end

end
