class TestsController < Simpler::Controller

  def index
    @time = Time.now
    #render plain: 'plain text'
  end

  def create

  end

  def show
    render plain: "#{params}"
  end

end
