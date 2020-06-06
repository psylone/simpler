# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    status 201
    @time = Test.all
  end

  def show
    # headers['Content-Type'] = 'text/html'
    @test = Test.find(params[:id])
    render plain: 'TEXT'
  end
end
