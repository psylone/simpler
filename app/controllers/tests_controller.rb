class TestsController < Simpler::Controller

  def index
     @tests = Test.all
     # render plain: "some text"
     set_headers("text/html")
     set_status("200")
  end

  def show
    # render plain: "some text"
    @params = self.params
    @test = Test.where(id: @params[":id"]).all
    set_status("200")
  end

  def new
  end

  def create
    set_status("201")
  end

end
