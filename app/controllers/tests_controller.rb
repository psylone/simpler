class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render 'tests/list'
    status 200
  end

  def create
    render plain: "txt"
    status 201
  end

end
