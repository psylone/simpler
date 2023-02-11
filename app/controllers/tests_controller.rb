class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: 'Just simple text'

    render 'tests/list'
  end

  def create

  end

end
