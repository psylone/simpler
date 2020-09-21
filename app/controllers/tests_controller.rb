class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all
    # render plain: Time.now
    # render plain: 'Plain text response'
  end

  def create
    render plain: 'Plain text response'
    status 201
  end

  def show
    @id = params[:id]
  end

end
