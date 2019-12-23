class TestsController < Simpler::Controller

  def index
    @time = Time.now

    render plain: "Plain text response"
    status 200
  end

  def create
    render plain: "Test created"
    status 201
  end

  def show
    @test_id = params[:id]

    render 'tests/list'
  end

end
