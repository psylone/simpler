class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 200
    headers['Content-Type'] = 'text/html'
  end

  def show
    render plain: "Render plain for test with id: #{params[:id]}"
  end

  def create

  end

end
