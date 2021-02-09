class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    #render 'tests/list'
    #render plain: "Plain text response"
    headers["X-Header"] = "My new header"
  end

  def create

  end

  def show
    @test = Test.first(:id => params[:id])
  end

end
