# frozen_string_literal: true

# Test Controller
class TestsController < Simpler::Controller
  def index
    @time = Time.now
    # self.status = 400
    # headers['HELLO'] = params[:id]
    # render plain: 'HELLO!!!',
    #        headers: { 'Content-Type' => 'text', 'Baraguza' => 'text' }
  end

  def create; end
end
