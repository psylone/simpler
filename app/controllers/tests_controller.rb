class TestsController < Simpler::Controller

  def index
    @time = Time.now
    set_status 201
  end

  def create

  end

end
