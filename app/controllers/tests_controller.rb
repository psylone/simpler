# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: 'Some plain text'
  end

  def create; end

  def show
    render plain: "Params: #{params} Id: #{params[:id]}, name: #{@name}"
  end
end
