# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render 'tests/list'
  end

  def create
    status 201
    render plain: 'Create an action!'
  end

  def show
    @time = params[:id]
  end
end
