class TestsController < Simpler::Controller

  def index
    render plain: 'tests'
  end

  def create

  end

  def show
    render plain: "Show test with id #{params[:id]}"
  end

end
