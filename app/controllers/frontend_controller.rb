class FrontendController < ApplicationController
  def show
    if !params["history"]
      redirect_to admin_dashboard_path
    end
  end
end
~                                                                                                                                                      
~                                                                                                                                                      
~                                                                                                                                                      
~                                              
