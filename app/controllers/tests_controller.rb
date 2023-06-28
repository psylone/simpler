class TestsController < Simpler::Controller
  def index
    render 'tests/index'
    status 200
  end

  def create
    status 201
  end

  def show
    @test_id = params[:id]
    render 'tests/show'
  end
end
