# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    render plain: 'Plain text response'
  end

  def list
    @tests = Test.all
  end

  def create; end

  def show
    @test = params
  end
end
