class TestsController < Simpler::Controller

  def index
    @time = Time.now

    status 200
  end

  def create

    status 201
  end

end
