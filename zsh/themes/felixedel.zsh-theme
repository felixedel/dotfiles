# This theme is based on robbyrussel's default ZSH theme, but adds a few
# features from the agnoster theme.
#
# For reference:
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/git.zsh
# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/agnoster.zsh-theme

PYTHON_ICON='\ue606'
AWS_ICON='\ue7ad'
BRANCH_ICON='\ue725'
COMMIT_ICON='\ue729'

# Print the current venv (if sourced)
prompt_virtualenv() {
  local virtualenv_path="${VIRTUAL_ENV}"
  if [[ -n ${virtualenv_path} && -n ${VIRTUAL_ENV_DISABLE_PROMPT} ]]; then
    echo -n "%{$fg[green]%}(${PYTHON_ICON} $(basename ${VIRTUAL_ENV}))"
    #echo "($(basename ${VIRTUAL_ENV})) "
  fi
}

prompt_aws() {
  if [[ -n "${AWS_PROFILE}" ]]; then
    echo -n "%{$fg[blue]%}(${AWS_ICON} ${AWS_PROFILE})"
  fi
}

# Print the current working directory
prompt_dir() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    # If we are in a git repository, print the path relatively to the repo root
    local git_root=$(git rev-parse --show-toplevel)
    dir="$git_root:t${${PWD:A}#$~~git_root}"
  else
    # Otherwise print the path relative to our HOME directory (starting with ~)
    # or the absolute path if we are not somewhere in our HOME directory.
    dir='%~'
  fi

  echo "${dir}"
}

prompt_git() {
  local repo_path ref dirty mode untracked_files
  local clean_ref state_color dirty_mark prefix suffix
  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    # Use the symbolic ref (branch), but fall back to the short commit ID
    ref="${BRANCH_ICON} $(git symbolic-ref HEAD 2>/dev/null)" || ref="${COMMIT_ICON} $(git rev-parse --short HEAD 2>/dev/null)"
    # Chec if the repo is dirty (and contains untracked files). Using only the
    # last line is sufficient. The untracked_files will also be set if the repo
    # is dirty, but doesn't contain untracked files. But for the if/else branch
    # further down this is sufficient.
    untracked_files=$(git status --porcelain 2>/dev/null | tail -n 1)
    dirty=$(git status --porcelain --untracked-files=no 2>/dev/null | tail -n 1)

    # Check if we are currently in any bisect|merge|rebase mode
    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" [<B>]"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" [>M<]"
    elif [[ -e "${repo_path}/CHERRY_PICK_HEAD" ]]; then
      mode=" [<CP<]"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" ]]; then
      mode=" [>R>]"
    fi

    # In case everything is fine, show a green ref name without any dirty mark.
    # This should rarely be the case.
    state_color="%{$fg[green]%}"
    # Show a red ref name together with a dirty mark if the repo contains local
    # changes to tracked files.
    if [[ -n ${dirty} ]]; then
      state_color="%{$fg[magenta]%}"
      dirty_mark=" %{$fg[yellow]%}✗"
    # Show a red ref name, but no dirty mark if the repo contains only untracked
    # files, but no changes.
    elif [[ -n ${untracked_files} ]]; then
      state_color="%{$fg[magenta]%}"
    fi

    # Build the git prompt
    prefix="%{$fg[blue]%}("  # blue "("
    suffix="%{$fg[blue]%})"  # blue ")"
    # Strip the "refs/heads/" from the ref name
    clean_ref=${ref/refs\/heads\/}

    echo -n "${prefix}${state_color}${clean_ref}${suffix}"
    echo -n "%{$fg_bold[red]%}${mode}${dirty_mark}%{${reset_color}%} "
  fi
}

# Primary prompt
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}✘ )%{${reset_color}%}"
PROMPT+='%{$fg_bold[cyan]%}$(prompt_dir) $(prompt_git)'

# Right prompt
RPS1='$(prompt_virtualenv) $(prompt_aws)'
