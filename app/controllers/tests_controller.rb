class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @id = params[:id]
    render plain: 'tests/plain'	    headers['Content-Type'] = 'text/plain'
    # render plain: 'tests/plain'
  end

  def create; end

  def show
    @id = params[:id]
  end

end
