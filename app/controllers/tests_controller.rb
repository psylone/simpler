class TestsController < Simpler::Controller

  def index
    status 201
    headers['Content-Type'] = 'text/plain'
  end

  def create
    
  end

  def show
    render plain: "Test id: #{params[:id]}"
  end

end
