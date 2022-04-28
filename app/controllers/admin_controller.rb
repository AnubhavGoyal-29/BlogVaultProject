class AdminController < ApplicationController
  def websites
    redirect_to admin_websites_path
  end
end
