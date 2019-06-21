class TestsController < Simpler::Controller

  def index
    # @time = Time.now
    render plain: Time.now
    # render html: 'tests/list'
  end

  def create

  end

  def show
    @id = params[:id]
  end

end
