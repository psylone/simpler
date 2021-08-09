class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def show
    @id = params[:id]
  end

  def text
    status 201
    render plain: 'Plain text response'
  end

  def header
    headers['Content-Type'] = 'text/plain'
    render 'tests/index'
  end

  def create

  end

end
