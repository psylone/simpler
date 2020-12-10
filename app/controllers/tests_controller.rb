class TestsController < Simpler::Controller

  def index
    render 'tests/index'
    # render plain: "Plain text responce"

    @time = Time.now
  end

  def create

  end

end
