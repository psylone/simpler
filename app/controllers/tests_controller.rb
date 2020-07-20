class TestsController < Simpler::Controller

  def index
    status(201)
    render template: 'tests/index'
  end

  def show
    render "trying to show test with id #{params[:id]}"
  end

  def create; end

end
