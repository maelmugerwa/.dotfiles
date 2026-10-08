# Amazon-machine module. No-op on personal hosts (WSL, macOS, generic Linux).
#
# The guard matches amazon.zsh. An Amazon Mac has ~/.toolbox but no /apollo/env
# until Brazil creates its first workspace. A bare /apollo/env test hides b, bb
# and every eda alias there. Desktop-only lines carry their own inner guard.
[[ -d /apollo/env || -d "$HOME/.toolbox" ]] || return 0

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short

export AUTO_TITLE_SCREENS="NO"


set-title() {
    echo -e "\e]0;$*\007"
}

ssh() {
    set-title "$*"
    command ssh "$@"
    set-title "$HOST"
}

# Meshclaw
alias mc_update='cp ~/.meshclaw/config.json ~/.meshclaw/config.json.bak.$(date +%Y%m%d) && meshclaw update'

# AAA
alias register-with-aaa="/apollo/env/AAAWorkspaceSupport/bin/register_with_aaa.py"

# Toolbox
export PATH=$HOME/.toolbox/bin:$PATH

# Cloud desktop only. An Amazon Mac has no envImprovement.
[[ -d /apollo/env/envImprovement/bin ]] && export PATH=$PATH:/apollo/env/envImprovement/bin

# Set CSC_UI_ODIN_MATERIAL_SET and CSC_UI_LOCAL_DATA_PROXY in
# ~/.config/zsh/secrets.zsh (gitignored). The values are per-host and internal.
# Never commit corp hostnames.

# Run ls after every cd.
chpwd() ls -F

# Midway and Kerberos auth.
alias auth='mwinit -o -s'
alias login='kinit -f && mwinit -o -s'

# Reload .zshrc.
reload() {
    source ~/.zshrc >/dev/null 2>&1
}

# Send a Slack build notification.
# Set BUILD_SLACK_WEBHOOK in ~/.config/zsh/secrets.zsh (gitignored) to enable.
# Without it this returns immediately. b() and brazil-build-wrapper() call it on
# every build, so an unset webhook must never fire a curl.
slack() {
    [[ -n "${BUILD_SLACK_WEBHOOK:-}" ]] || return 0

    local pwd=$1
    local command=$2
    local exit_status=$3
    local duration=$4
    local hostname=$(hostname)

    local short_pwd=${pwd#/workplace/$USER}

    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    local content
    if [[ $exit_status -eq 0 ]]; then
        content="Success! :tada:"
    else
        content="Failed with code $exit_status! :fire:"
    fi

    curl -fsS --max-time 5 -X POST "$BUILD_SLACK_WEBHOOK" \
         -H "Content-Type: application/json" \
         --data "{\"Message\":\"$content (${minutes}m ${seconds}s)\", \"pwd\": \"$short_pwd\", \"command\": \"$command\"}" \
         > /dev/null 2>&1 || true
}

# Wrap brazil-build to notify Slack.
brazil-build-wrapper() {
    local start_time=$(date +%s)
    local pwd=$(pwd)
    local full_command="brazil-build $*"

    command brazil-build "$@"
    local exit_status=$?

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    slack "$pwd" "$full_command" "$exit_status" "$duration"

    return $exit_status
}

alias brazil-build='brazil-build-wrapper'

# brazil aliases
alias e='emacs'
alias bb='brazil-build'
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwsuse='bws use -p'
alias bwscreate='bws create -n'
alias brc='brazil-recursive-cmd'
alias bbr='brc brazil-build'
alias bball='brc -all --continue'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'
# recursive bb
alias recclean='brazil-recursive-cmd -all "bb clean & bb"'

# compact git log
alias glo="git log --max-count=5 --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# eda aliases
alias crebase="eda rebase --current-package"
alias cpush="eda push --current-package"
alias cmerge="eda merge --current-package"

# Wrap eda build to notify Slack.
b() { # ex: b --silent release
    local start_time=$(date +%s)
    local pwd=$(pwd)
    local full_command="eda build"
    local silent=false

    if [[ "$1" == "--silent" ]]; then
        silent=true
        shift
    fi

    if $silent; then
        full_command+=" --silent"
        command eda build --silent brazil-build "$@"
    else
        command eda build brazil-build "$@"
    fi

    local exit_status=$?

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    slack "$pwd" "$full_command" "$exit_status" "$duration"

    return $exit_status
}
alias c="brazil ws --sync --md && brazil ws clean"
alias cb="brazil ws --sync --md && brazil ws clean && b"
alias cbr="brazil ws --sync --md && brazil ws clean && b release"
alias pl="eda run git pull --rebase --autostash"
alias lock="eda run git checkout mainline -- package-lock.json || true"
alias rmrf="eda run rimraf node_modules dist coverage build"
alias morning="lock && pl && cb"
alias reset="mainline && rmrf && morning"
alias log="eda run git log --max-count=5 --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit | cat"
alias st="eda st"
alias status="eda fetch && eda st"

# Is a package in the live version set?
inLive(){
    command='brazil pkg print -vs live -p '
    read "packageName?Which packageName? "; command+="${packageName}"
    read "versionNumber?Which versionNumber? "; command+=" --mv ${versionNumber}"
    echo "$command\n"; eval "$command"
}

# Kill whatever listens on a port.
killPort() { # $1 is the port number
    kill $(lsof -t -i:"${1}")
}

# Free disk space on a cloud desktop.
clean() {
    # Install ncdu to find large files:
    # sudo rpm -Uvh http://archives.fedoraproject.org/pub/archive/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm
    # sudo yum clean all
    # sudo yum makecache
    # sudo yum install -y ncdu

    # Reference: https://w.amazon.com/bin/view/AWS/IoT/Rules/Tutorials/cleanclouddesktopspace/
    if read -qs "choice?Press Y/y to prune docker"; then
        sudo docker system prune -a -f
    fi; echo "\n"
    if read -qs "choice?Press Y/y to clean brazil cache"; then
        brazil-package-cache clean --days 0 --keepCacheHours 0
    fi; echo "\n"
}
