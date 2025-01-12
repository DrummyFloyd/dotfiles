function extract() {
  if [ -f "${1}" ]; then
    case $1 in
      *.tar.bz2) tar xvjf "$1" --one-top-level ;;
      *.tar.gz) tar xvzf "$1" --one-top-level ;;
      *.tar.xz) tar xvf "$1" --one-top-level ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function selrsync() {
  # selective rsync to sync only certain filetypes;
  # based on: https://stackoverflow.com/a/11111793/588867
  # Example: selrsync 'tsv,csv' ./source ./target --dry-run
  types="$1"
  shift #accepts comma separated list of types. Must be the first argument.
  includes=$(echo "$types" | awk -F',' \
    'BEGIN{OFS=" ";}
    {
    for (i = 1; i <= NF; i++ ) { if (length($i) > 0) $i="--include=*."$i; } print
    }')
  restargs="$@"

  echo Command: rsync -avz --prune-empty-dirs --include="*/" "$includes" --exclude="*" "$restargs"
  eval rsync -avz --prune-empty-dirs --include="*/" "$includes" --exclude="*" "$restargs"
}

# function check_npm_packages(){
#   package_name=${1}
#   if [[ "$(npm list -g $package_name)" =~ "empty" ]]; then
#     echo "Installing $package_name ..."
#     npm install -g $package_name
#   fi
# }

function multipull() {
  fd -H -I -t d .git . -x bash -c 'printf "pull of $(dirname {})\n";git -C $(dirname {}) pull origin'
}

function ns_killer() {
  NS=$(kubectl get ns | grep Terminating | awk 'NR==1 {print $1}') && kubectl get namespace "$NS" -o json | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" | kubectl replace --raw /api/v1/namespaces/"$NS"/finalize -f -
}

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interactive-ripgrep-launcher
ff() {
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="${*:-}"
  : | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2} || vim {1} +{2})'
}

# create and cd into a directory
function mkcd() {
  mkdir -p "$@" && cd "$_"
}
