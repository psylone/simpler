class TestsController < Simpler::Controller

  def index
     # @tests = Test.all
     render plain: "some text"
     set_status("200")
  end

  def show
    @params = self.params
    @test = Test.where(id: @params[:id]).all
    set_status("200")
  end

  def new
  end

  def create
    set_status("201")
  end

end
