class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: "Plain text response"
  end


  def create
  end

  def show
    @test_id = @request.params[:id]
  end

end
