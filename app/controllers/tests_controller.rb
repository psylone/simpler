class TestsController < Simpler::Controller

  def index
    @tests = Test.all
  end

  def create
    test = params['test']
    id = Test.insert(title: test['title'], level: test['level'].to_i)

    redirect_to("/tests/#{id}")
  end

  def new; end

  def show
    get_test
  end

  def edit
    get_test
  end

  def update
    get_test
    test = params['test']
    @test.update(title: test['title'], level: test['level'].to_i)

    redirect_to("/tests/#{@test.id}")
  end

  def destroy
    get_test
    @test.delete

    redirect_to('/tests', 301)
  end

  private

  def get_test
    @test = Test[params[:id].to_i]
    render plain: "Test not found", status: 404, headers: {'Content-Type' => 'text/plain'} if @test.nil?
  end
end
