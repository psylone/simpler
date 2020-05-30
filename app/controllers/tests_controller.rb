class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render 'tests/list'
    headers['Content-Type'] = 'application/json'
  end

  def create
    status 201
    render plain: 'Create an action!'
  end

  def show; end
end
