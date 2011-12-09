module ClippedFoldersAdminUI

 def self.included(base)
   base.class_eval do

      attr_accessor :folder
      alias_method :folders, :folder
      
      protected

 
        
    end
    
  end
end