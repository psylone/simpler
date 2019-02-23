class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all

    status(201)
    render plain: 'For Test Only ! '
  end

  def create; end

  def show
    render plain: 'SHOW ! Test Only ! '
  end
end
