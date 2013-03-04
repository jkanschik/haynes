class PublishersController < ApplicationController

  def show
    @publisher = Publisher.find(params[:id])
    @title = @publisher.label
  end

end
