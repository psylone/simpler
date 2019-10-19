class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: 'plain text message'
  end

  def create; end

  def show
    # render plain: "Test: #{params[:id]}"
    @params = params[:id]
    status(201)
    set_header('Test-Header', 'text/html')
  end

end
