class TestsController < Simpler::Controller

  def index
    status 201
    headers['Content-Type'] = 'text/plain'
    render  plain: 'tests'
  end

  def show
    render plain: "trying to show test with id #{params[:id]}"
  end

  def create; end

end
