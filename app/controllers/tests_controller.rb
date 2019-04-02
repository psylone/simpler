class TestsController < Simpler::Controller

  def index
    @time = Time.now
    # render plain: "Plain text response"
    # render 'tests/list'
    # status 201
  end

  def create

  end

  def show
    @id = params[:id]
  end

end
