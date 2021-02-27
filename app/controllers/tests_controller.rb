class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create
    render 'tests/list'
    #render plain: 'tests/list'
    set_header('Test', 'test')
    set_status(201)
  end

  def show
    @id = params[:id]
  end

end
