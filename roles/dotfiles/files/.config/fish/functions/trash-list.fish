function trash-list --wraps='gio trash --list' --description 'alias trash-list=gio trash --list'
  gio trash --list $argv
        
end
