# frozen_string_literal: true

class PlainRender
  attr_reader :header, :body
  def initialize(format)
    @body = format.values.join
    @header = 'text/plain'
  end
end
