class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: "test"
    status 200
    headers['Content-Type'] = 'text/plain'
  end

  def create; end

  def show
    @params = params
    render plain: params
  end
end
