class Admin::FoldersController < Admin::ResourceController
  
  before_filter :fetch_parent
  
  def show
    @folder = Folder.find(params[:id]) 

    respond_to do |format|
      format.html {  }
      format.js { render :show, :layout => false }
    end
  end
  
  def new
    model.parent = parent
    response_for :new
  end    
  
  protected
    def parent
      @parent
    end
    
    def fetch_parent
      @parent = Folder.find(params[:folder_id]) if params[:folder_id]
    end  
    
    def continue_url(options)  
      index_path = model.parent_id ? admin_folder_assets_path(model.parent_id) : admin_assets_path
      options[:redirect_to] || (params[:continue] ? {:action => 'edit', :id => model.id} : index_path)
    end
    
end