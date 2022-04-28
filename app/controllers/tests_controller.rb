class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all
    render plain: 'fefsfwefwfe'
    status 201
    headers content_type: 'text/plain', ohthth_rgrgr: 'vrvrvrvr'
  end

  def create

  end

  def show
    byebug
    @test = Test[params[:id]]
    status 205
  end

end
