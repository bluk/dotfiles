function check_terraform_workspace_and_git_branch --description "Checks that the terraform workspace and git branch match"
  set terraform_workspace (terraform workspace list | grep '*' | sed 's/\* //')
  set git_branch (git branch | grep '*' | sed 's/\* //')
  if test $terraform_workspace = $git_branch
    set argv_count (count $argv)
    if test $argv_count -lt 1
      echo "Script needs a command"
      return 1
    else
      eval $argv
    end
  else
    echo "Switch git branches ( $git_branch ) to match Terraform workspace ( $terraform_workspace )"
  end
end
