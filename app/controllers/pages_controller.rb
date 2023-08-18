class PagesController < ApplicationController
  def home
    @no_top_nav = true
    @clients = Client.all
  end
end
