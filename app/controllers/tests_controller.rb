class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end


  def show
    render plain: params['id']
  end

  def create

  end

end
