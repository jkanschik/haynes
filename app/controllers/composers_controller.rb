class ComposersController < ApplicationController
  def show
    @composer = Composer.find(params[:id])
    @title = "#{@composer.name}, #{@composer.first_name}"
  end
end
