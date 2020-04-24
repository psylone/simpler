# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    @time = Time.now
  end

  def create
    render plain: "Plain text response: we're rending from the create method"
  end
end
