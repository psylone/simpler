class TestsController < Simpler::Controller
  def index
    status 201
    @time = Time.now
    set_headers('Content-Type', 'B')
  end

  def create; end

  def show
    @test_id = params[':id']
  end
end
