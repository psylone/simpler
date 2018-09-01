class TestsController < Simpler::Controller

  def index
    # render 'tests/list'
    # render plain: "Plain text response\n", status: 201
    @time = Time.now
  end

  def create

  end

  def show
    @id = params
  end

end
