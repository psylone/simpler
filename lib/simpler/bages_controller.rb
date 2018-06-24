class BagesController < ApplicationController
  before_action :find_bages, only: %i[index]
  before_action :find_my_bages, only: %i[my_bages]

  def index
    
  end

  def my_bages

  end

  private

  def find_bages
    @bages = Bage.all
  end

  def find_my_bages
    @my_bages = current_user.bages
  end

end
