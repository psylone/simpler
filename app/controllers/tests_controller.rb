class TestsController < Simpler::Controller

  def index
    @tests =Test.all
  end

  def create

  end

  def show
    params = @request.env['simpler.params']
    @test = Test.find(id: params[:id])
    if @test.nil?  
      set_headers(:plain) 
      render plain: '404 Not found'
    else 
      @test
    end
  end
end
