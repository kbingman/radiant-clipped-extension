class Admin::AssetsController < Admin::ResourceController
  paginate_models(:per_page => 50)
  
  # Folders     
  def index
    assets = Asset.scoped({:order => "created_at DESC"})
    @folders = []
    
    @term = params[:search] || ''
    assets = assets.matching(@term) if @term && !@term.blank?
    
    @types = params[:filter] || []
    if @types.include?('all')
      params[:filter] = nil
      assets = assets.of_folder(params[:folder_id]) 
      @folders = Folder.all(:conditions => {:parent_id => params[:folder_id]})
    elsif @types.any?
      assets = assets.of_types(@types)  
    elsif @term == ''
      assets = assets.of_folder(params[:folder_id])  
      @folders = Folder.all(:conditions => {:parent_id => params[:folder_id]}) 
    end  

    @folder = Folder.find(params[:folder_id]) if params[:folder_id]

    @assets = paginated? ? assets.paginate(pagination_parameters) : assets.all
    respond_to do |format|
      format.html { render }
      format.js { 
        @page = Page.find_by_id(params[:page_id])
        render :partial => 'admin/folders/folder_grid', :locals => { :with_pagination => !!@page, :folders => @folders}
      }
    end
  end   
  
  # Folders     
  def new
    @asset.folder_id = params[:folder_id]
  end
 
  def create
    @assets, @page_attachments = [], []
    params[:asset][:asset].to_a.each do |uploaded_asset|
      @asset = Asset.create(:asset => uploaded_asset, :title => params[:asset][:title], :caption => params[:asset][:caption], :folder_id => params[:asset][:folder_id])
      if params[:for_attachment]
        @page = Page.find_by_id(params[:page_id]) || Page.new
        @page_attachments << @page_attachment = @asset.page_attachments.build(:page => @page)
      end
      @assets << @asset
    end

    if params[:for_attachment]
      render :partial => 'admin/page_attachments/attachment', :collection => @page_attachments
    else 
      # response_for :create
      redirect_to @asset.folder.nil? ? admin_assets_path : admin_folder_assets_path(@asset.folder)
    end
  end    
  
  def refresh
    if params[:id]
      @asset = Asset.find(params[:id])
      @asset.asset.reprocess!
      flash[:notice] = t('clipped_extension.thumbnails_refreshed')
      redirect_to edit_admin_asset_path(@asset)
    else
      render
    end
  end
  
  only_allow_access_to :regenerate,
    :when => [:admin],
    :denied_url => { :controller => 'admin/assets', :action => 'index' },
    :denied_message => 'You must have admin privileges to refresh the whole asset set.'

  def regenerate
    Asset.all.each { |asset| asset.asset.reprocess! }
    flash[:notice] = t('clipped_extension.all_thumbnails_refreshed')
    redirect_to admin_assets_path
  end 
  
  protected   
    
    # Folders 
    def continue_url(options)  
      index_path = model.folder_id ? admin_folder_assets_path(model.folder_id) : admin_assets_path
      options[:redirect_to] || (params[:continue] ? {:action => 'edit', :id => model.id} : index_path)
    end  

end
