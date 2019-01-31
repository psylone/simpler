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
    # NEED to merge :id from path_params to params of the controller to get access to it, don't know how to do it yet
#    @id = params[:id]
  end

  private

  def test_params
    params.require(:test).permit(:title, :level)
  end
end
