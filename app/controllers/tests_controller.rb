class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all
    headers['Content-Type']
    status(201)
    # render plain: 'For Test Only ! '
  end

  def create; end

  def show
    @time = Time.now
    # render plain: 'SHOW ! Test Only ! '
    @params = params
  end
end
