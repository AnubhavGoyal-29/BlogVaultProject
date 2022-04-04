class WordpressController < ApplicationController
  def show
    @websites = Website.all
  end
end
