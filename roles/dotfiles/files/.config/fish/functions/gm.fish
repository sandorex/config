function gm --wraps='git merge --no-commit --no-ff' --description 'alias gm=git merge --no-commit --no-ff'
  git merge --no-commit --no-ff $argv
        
end
