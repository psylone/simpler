class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    # render plain: "some text"
  end

  def show

  end

end
