class LanguagesController < ApplicationController

  def index
    @languages = Language.all
  end

  private

  def language_params
    params.require(:language).permit(:abbreviation)
  end

end
