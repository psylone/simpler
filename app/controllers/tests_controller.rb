class TestsController < Simpler::Controller

  def index
    @time = Time.now
    # headers['Content-Type'] = 'text/plain'
    #render plain: 'Plain text response', status: 201
    status 404
   
    @tests = Test.all
  end

  def create
  end

  def show
    #@test = Test.first(id: params[:id])
   p params
  end
end
