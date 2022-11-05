class TestsController < Simpler::Controller

  def index
    @tests = Test.all
  end

  def create; end
end
