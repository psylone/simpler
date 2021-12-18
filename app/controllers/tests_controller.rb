class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all
    # status 202
    # headers['Content-Type'] = 'text/plain'
    # render plain: 'tests/list'
    # render 'tests/list'
  end

  def create; end

  def show
    @test = Test.find(id: params[:id])
    if @test.nil?
      status 404
      headers['Content-Type'] = 'text/plain'
      render plain: 'Not found'
    end
  end

end
