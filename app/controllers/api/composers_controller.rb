class Api::ComposersController < Api::ApiController
  def show
    composer = Composer.find(params[:id])
    render :json => composer
  end
end
