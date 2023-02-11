class TestsController < Simpler::Controller

  def index
    @time = Time.now

    #render 'tests/list'
    #render plain: 'Just simple text'
  end

  def create

  end

end
