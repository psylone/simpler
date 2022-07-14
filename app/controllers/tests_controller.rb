class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: "#{@time} This is text from Plain"
  end

  def create
    render plain: 'This is text from Plain create'
  end

  def show
    @test = Test.where(id: params[:id])
    render plain: "Action Show:   params: #{params}, @test = #{@test} "
  end
end
