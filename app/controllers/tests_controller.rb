class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
    headers['Content-Type'] = 'text/plain'
  end

  def show
    Test.find_by(params[:id])
  end

  def create

  end

end
