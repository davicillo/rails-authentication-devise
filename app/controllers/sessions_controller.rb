class SessionsController  < Devise::SessionsController
  #skip_before_filter :verify_authenticity_token
  skip_before_filter :verify_authenticity_token, only: [:destroy]

  

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => '#{controller_path}#failure')
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in_and_redirect(resource_name, resource)
  end
 
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    respond_to do |format|
        format.json { render :json => {:success => true, :content => render_to_string(:layout => false, :partial => 'layouts/signed_in_options.html.erb')}, :status => :ok }
        format.html { respond_with resource, :location => after_sign_in_path_for(resource) } 
    end
    #return render :json => {:success => true, :content => render_to_string(:layout => false, :partial => 'layouts/signed_in_options')}
  end
 
  def failure
    return render :json => {:success => false, :errors => ["Login failed."]}
  end

end