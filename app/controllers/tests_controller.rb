# frozen_string_literal: true

class TestsController < Simpler::Controller

  def index
    @time = Time.now
    @tests = Test.all
  end

  def create
  end

  def show
    @test = find_test(params[:id])
    if @test.nil?
      response_error
    end
  end

  private

  def find_test(id)
    Test.find(id: id)
  end

  def response_error
    status 404
    headers['Content-Type'] = 'text/plain'
    render plain: 'Test not found'
  end
end
