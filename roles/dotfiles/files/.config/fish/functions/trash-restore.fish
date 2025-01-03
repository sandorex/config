function trash-restore --wraps='gio trash --restore' --description 'alias trash-restore=gio trash --restore'
  gio trash --restore $argv
        
end
