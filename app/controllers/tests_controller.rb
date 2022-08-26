# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    @tests = Test.all
    # render plain: "ololo"
    status 201
  end

  def show
    @test = Test.find(id: @params[:id])
  end

  def create; end
end
