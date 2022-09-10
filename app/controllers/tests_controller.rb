# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    @time = Time.now
    # render 'tests/list'
  end

  def no_content
    status 204
  end

  def plain_text
    render plain: 'Hello world'
  end

  def show
    find_test
  end

  def create
    render json: { hi: 'hello' }
  end

  private

  def find_test
    @test = Test.find(params[:id])
  end
end
