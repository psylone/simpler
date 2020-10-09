class TestsController < Simpler::Controller

  def index
     render plain: 'tests'
  end

  def create

  end

  def show
    render plain: "Show test #{params[:id]}"
  end

end
