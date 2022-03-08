class TestsController < Simpler::Controller

  def index
    @time = Time.now

    # headers['My-Custom-Head'] = 'some-info'
    # status 333
    # render plain: 'all is ok'
  end

  def create
    # render plain: 'all is ok'
  end

  def show

  end

end
