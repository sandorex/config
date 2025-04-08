function gm --wraps='git merge --no-commit --squash' --description 'alias gm=git merge --no-commit --squash'
  git merge --no-commit --squash $argv
        
end
