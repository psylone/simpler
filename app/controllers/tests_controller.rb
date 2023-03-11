class TestsController < Simpler::Controller

  def index
    headers['Content-Type'] = 'application/json'
    @time = Time.now
    render 'tests/list'
  end

  def  show

  end

  def create
    status 201
    render plain: 'create action'
  end

end
