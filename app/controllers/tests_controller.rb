# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    @time = Time.now
  end

  def create; end

  def plain
    render plain: 'plain_option_example'
    status 201
  end

  def show
    @id = params[:id]
    render plain: "This is an object (show tests method) with id #{@id}"
  end

  def question
    @id = params[:id]
    render plain: "This is an object with test id #{@id} and with question id #{params[:question_id]}"
  end
end
