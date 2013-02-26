module Admin::FoldersHelper
  
  def asset_insertion_link(asset)
    radius_tag = asset.asset_type.default_radius_tag || 'link'
    display_size = Radiant::config['assets.display_size'] || 'normal' 
    link_to t('clipped_extension.insert'), asset.thumbnail(display_size.to_sym), :class => 'insert_asset', :rel => "#{radius_tag}_#{Radiant.config['assets.insertion_size']}_#{asset.id}"
  end
  
end