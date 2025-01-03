function gl --wraps='git log --oneline' --description 'alias gl=git log --oneline'
  git log --oneline $argv
        
end
