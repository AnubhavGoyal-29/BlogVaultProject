class FrontendController < ApplicationController

  def site_timeline
    if !params["history"]
      redirect_to admin_dashboard_path
    end
  end

  def cms_distribution
    if params[:cms_distribution].present?
      if params[:cms_distribution][:start_date] > params[:cms_distribution][:end_date]
        flash[:notice] = "please select date in correct order"
      end
    end
  end

  def source_timeline
  end

end

