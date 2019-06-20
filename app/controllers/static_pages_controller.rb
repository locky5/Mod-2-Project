class StaticPagesController < ApplicationController

  def home
    @top_three_channels = Channel.get_live_streams(api_args: "first=3")
  end

end
