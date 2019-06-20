class StaticPagesController < ApplicationController

  def home
    @top_channels = Channel.get_live_streams(api_args: "first=5")
  end

end
