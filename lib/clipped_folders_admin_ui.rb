module ClippedFoldersAdminUI

 def self.included(base)
   base.class_eval do

      attr_accessor :folder
      alias_method :folders, :folder
      
      protected
      
        def load_default_folder_regions
          returning OpenStruct.new do |folder|
            folder.edit = Radiant::AdminUI::RegionSet.new do |edit|
              edit.main.concat %w{edit_header edit_form}
              edit.form.concat %w{edit_title edit_extended_metadata edit_content}
              edit.form_bottom.concat %w{edit_buttons edit_timestamp}
            end
            folder.new = folder.edit
            folder.index = Radiant::AdminUI::RegionSet.new do |index|
              index.top.concat %w{filters}
              index.bottom.concat %w{}
              index.thead.concat %w{thumbnail_header content_type_header actions_header}
              index.tbody.concat %w{thumbnail_cell title_cell content_type_cell actions_cell}
              index.paginate
            end
            folder.remove = folder.children = folder.show = folder.index 
          end
        end

 
        
    end
    
  end
end