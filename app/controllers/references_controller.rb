class ReferencesController < ApplicationController

  def show
    @reference = Quotation.find(params[:id])
    @title = @reference.label
  end

end
