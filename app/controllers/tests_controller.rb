class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render 'tests/list'
    status 200
  end

  def create
    render plain: "txt"
    status 201
  end

  def show
    @test_id = params[:id]
    render 'tests/list'
  end
end
