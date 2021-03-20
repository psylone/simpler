class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: "#{@request}"
  end

  def create
    render plain: 'Status 201 here'
    status 201
  end

  def show
    @id = params[:id]
  end

end
