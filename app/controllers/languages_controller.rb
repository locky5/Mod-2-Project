class LanguagesController < ApplicationController

  def index
    @languages = Language.all
  end

  def show
    @language = Language.find(params[:id])
    @channels = Channel.get_live_streams(api_args: "first=20&language=#{@language.abbreviation}")
  end

  private

  def language_params
    params.require(:language).permit(:abbreviation)
  end

end
