class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all
  end

  def create
    render plain: "Test create!"
  end

  def show
    @id = params[:id]
  end

end
