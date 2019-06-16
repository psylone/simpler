class TestsController < Simpler::Controller

  def index
    ## render plain: "* Simpler Tests *"
    ## render xml: 'tests/info'
    render 'tests/list'

    @time = Time.now
  end

  def show; end

  def create; end
end
