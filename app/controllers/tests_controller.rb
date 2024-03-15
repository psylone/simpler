class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: "Text for render"
    status 201
    headers['Content-Type'] = 'text/plain'
  end

  def create
  end

  def show
    render plain: "id #{@request.env[:id]}"
  end

end
