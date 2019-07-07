class TestsController < Simpler::Controller
  def index
    # @time = Time.now
    render plain: Time.now
  end

  def show
    @id = params[:id]
  end

  def create; end
end
