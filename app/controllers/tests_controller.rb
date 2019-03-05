class TestsController < Simpler::Controller

  def index
    render text: "This is index_action"
    # @tests = Test.all
    # @time = Time.now
  end

  def create

  end

  def show
    render text: "This is show_action"
    # @test = Test.first(params)
  end

end
