class TestsController < Simpler::Controller
  def index
    @time = Time.now
    # @tests = Test.find(1)
    # render plain: "Plain text response!!!"
    # render json: @tests
    # headers['Content-Type'] = 'text/plain'
    # headers['Content-Type'] = 'text/html'
    # headers 'text/html'
    # headers 'text/plain'
  end

  def create; end

  def show
    @params = params[:id]
  end

  def list; end
end
