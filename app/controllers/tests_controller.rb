class TestsController < Simpler::Controller
  def index
    @time = Time.now
    #list
    #render plain: "Plain text response", content_type: 'text/plain', status: 204
  end

  def list
    render html: "<h1><i>HERE WE GO </i></h1>", status: 202
  end

  def create
    @test = Test.new(test_params)
  end

  def show
    
  end

  private

  def test_params
    params.require(:test).permit(:title, :level)
  end

end
