class TestsController < Simpler::Controller

  def index
    @time = Time.now
    #render plain: 'tests/list'
    status(201)
  end

  def create
  end

  def show
    action_params
  end

end
