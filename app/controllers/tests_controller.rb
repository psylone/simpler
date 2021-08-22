class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    status 200
    headers['Content-Type'] = 'text/html'
  end

  def create

  end

  def show
    @parameter = params[:id]
  end

end
