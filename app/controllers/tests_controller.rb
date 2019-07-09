class TestsController < Simpler::Controller

  def index
  end

  def create

  end

  def show
    @param = params(:id)
  end

end
