# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    @time = Time.now
  end

  def create
    status 201

    render plain: "Plain text response: we're rending from the create method"
  end
end
