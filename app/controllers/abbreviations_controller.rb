class AbbreviationsController < ApplicationController
  layout 'popup'
  def show
    @abbreviations = Abbreviation.find(:all)
  end
end
