class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def show
    @test = params[:id]
  end

  def question_show
    @test, @qst = params[:id], params[:question_id] 
  end

  def create

  end

end
