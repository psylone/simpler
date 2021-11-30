class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create; end

  def show
    # @params = params.self
    @test_id = @request.params[:id]
  end

end
