# Cloud-desktop-only module. No-op on other hosts (WSL, macOS, generic Linux).
[[ -d /apollo/env ]] || return 0

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

# Add envImprovement to PATH
export PATH=$PATH:/apollo/env/envImprovement/bin

# Redfort/Odin cert material-set and local data proxy are per-host and internal.
# Set CSC_UI_ODIN_MATERIAL_SET and CSC_UI_LOCAL_DATA_PROXY in
# ~/.config/zsh/secrets.zsh (gitignored) -- never commit corp hostnames.

# on context change (ex: on cd) call ls
chpwd() ls -F

# midway + kerberos auth
alias auth='mwinit -o -s'
alias login='kinit -f && mwinit -o -s'

# reload zhsrc
reload() {
    source ~/.zshrc >/dev/null 2>&1
}

# Function to send Slack notification
slack() {
    local pwd=$1
    local command=$2
    local exit_status=$3
    local duration=$4
    local hostname=$(hostname)

    # Remove '/workplace/maelmug' from the pwd
    local short_pwd=${pwd#/workplace/$USER}

    # Convert duration to minutes and seconds
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    # Construct the message based on exit status
    local content
    if [[ $exit_status -eq 0 ]]; then
        content="Success! :tada:"
    else
        content="Failed with code $exit_status! :fire:"
    fi

    WEBHOOK="REDACTED_SLACK_WEBHOOK_URL" # Replace with your actual webhook URL when needed
    curl -X POST "$WEBHOOK" \
         -H "Content-Type: application/json" \
         --data "{\"Message\":\"$content (${minutes}m ${seconds}s)\", \"pwd\": \"$short_pwd\", \"command\": \"$command\"}"
}

# Wrap brazil-build function
brazil-build-wrapper() {
    local start_time=$(date +%s)
    local pwd=$(pwd)
    local full_command="brazil-build $*"

    # Call the original brazil-build function
    command brazil-build "$@"
    local exit_status=$?

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    # Send notification to Slack
    slack "$pwd" "$full_command" "$exit_status" "$duration"

    return $exit_status
}

# Set up alias to use the wrapper
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

# wrap eda build functions to send notifications
b() { # ex: b --silent release
    local start_time=$(date +%s)
    local pwd=$(pwd)
    local full_command="eda build"
    local silent=false

    # Check for --silent argument
    if [[ "$1" == "--silent" ]]; then
        silent=true
        shift  # Remove --silent from the arguments
    fi

    # Construct the command
    if $silent; then
        full_command+=" --silent"
        command eda build --silent brazil-build "$@"
    else
        command eda build brazil-build "$@"
    fi

    local exit_status=$?

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    # Send notification to Slack
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

# is package in live?
inLive(){
    command='brazil pkg print -vs live -p '
    read "packageName?Which packageName? "; command+="${packageName}"
    read "versionNumber?Which versionNumber? "; command+=" --mv ${versionNumber}"
    echo "$command\n"; eval "$command"
}

# kill port
killPort() { #$1 is first arg (here: port number)
    kill $(lsof -t -i:"${1}")
}

# cleanup clouddesk
clean() {
    # install and use ncdu to find and delete large files
    # sudo rpm -Uvh http://archives.fedoraproject.org/pub/archive/epel/7/x86_64/Packages/e/epel-release-7-14.noarch.rpm
    # sudo yum clean all
    # sudo yum makecache
    # sudo yum install -y ncdu

    # free up space https://w.amazon.com/bin/view/AWS/IoT/Rules/Tutorials/cleanclouddesktopspace/
    if read -qs "choice?Press Y/y to prune docker"; then
        sudo docker system prune -a -f
    fi; echo "\n"
    if read -qs "choice?Press Y/y to clean brazil cache"; then
        brazil-package-cache clean --days 0 --keepCacheHours 0
    fi; echo "\n"
}
