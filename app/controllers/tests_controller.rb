class TestsController < Simpler::Controller

  def index
    # render plain: 'haha'
  end

  def create

  end

  def show
    id = params[:id].to_i
    @test = Test.all.find { |t| t[:id] == id }
  end

end
