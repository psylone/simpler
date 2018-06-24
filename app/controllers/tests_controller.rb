class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    # render plain: "some text"
  end

  def show
    @params = self.params
    @test = Test.where(id: @params).all
  end

  def new
  end

  def create
  end

end
