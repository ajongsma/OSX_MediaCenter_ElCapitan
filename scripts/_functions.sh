#!/bin/bash
echo "loading _functions"

abort() {
  echo "$1"
  exit 1
}

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask() {
    print_question "$1"
    read
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -n 1
    printf "\n"
}

ask_for_sudo() {
    # Ask for the administrator password upfront
    sudo -v &> /dev/null

    # Update existing `sudo` time stamp until this script has finished
    # https://gist.github.com/cowboy/3118588
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &
}

brew_install() {
    declare -r CMD="$4"
    declare -r FORMULA="$2"
    declare -r FORMULA_READABLE_NAME="$1"
    declare -r TAP_VALUE="$3"

    # Check if `Homebrew` is installed
    if ! cmd_exists 'brew'; then
        print_error "$FORMULA_READABLE_NAME (\`brew\` is not installed)"
        return 1
    fi

    # If `brew tap` needs to be executed, check if it executed correctly
    if [ -n "$TAP_VALUE" ]; then
        if ! brew_tap "$TAP_VALUE"; then
            print_error "$FORMULA_READABLE_NAME (\`brew tap $TAP_VALUE\` failed)"
            return 1
        fi
    fi

    # Install the specified formula
    if brew "$CMD" list "$FORMULA" &> /dev/null; then
        print_success "$FORMULA_READABLE_NAME"
    else
        execute "brew $CMD install $FORMULA" "$FORMULA_READABLE_NAME"
    fi
}

brew_tap() {
    brew tap "$1" &> /dev/null
}

cmd_exists() {
    command -v "$1" &> /dev/null
    return $?
}

current_folder() {
    SOURCE="${BASH_SOURCE[0]}"
    DIR="$( dirname "$SOURCE" )"
    while [ -h "$SOURCE" ]
    do
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
      DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    return $?
}

download() {
    local url="$1"
    local output="$2"

    if command -v 'curl' &> /dev/null; then
        curl -LsSo "$output" "$url" &> /dev/null
        #     │││└─ write output to file
        #     ││└─ show error messages
        #     │└─ don't show the progress meter
        #     └─ follow redirects
        return $?
    elif command -v 'wget' &> /dev/null; then
        wget -qO "$output" "$url" &> /dev/null
        #     │└─ write output to file
        #     └─ don't show output
        return $?
    fi
    return 1
}

execute() {
    eval "$1" &> /dev/null
    print_result $? "${2:-$1}"
}

extract() {
    local archive="$1"
    local outputDir="$2"

    if command -v 'tar' &> /dev/null; then
        tar -zxf "$archive" --strip-components 1 -C "$outputDir"
        return $?
    fi
    return 1
}

file_exists() {
    if [ -f "$1" ]; then
        return $?
    else
        return 1
    fi
}

folder_exists() {
    if [ -d "$1" ]; then
        return $?
    else
        return 1
    fi
}

get_answer() {
    printf "$REPLY"
}

get_os() {
    declare -r OS_NAME="$(uname -s)"
    local os=''

    if [ "$OS_NAME" == "Darwin" ]; then
        os='osx'
    elif [ "$OS_NAME" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
        os='ubuntu'
    else
        os="$OS_NAME"
    fi

    printf "%s" "$os"
}

get_os_arch() {
    printf "%s" "$(getconf LONG_BIT)"
}

is_git_repository() {
    git rev-parse &> /dev/null
    return $?
}

is_supported_version() {
    declare -a v1=(${1//./ })
    declare -a v2=(${2//./ })
    local i=''

    # Fill empty positions in v1 with zeros
    for (( i=${#v1[@]}; i<${#v2[@]}; i++ )); do
        v1[i]=0
    done

    for (( i=0; i<${#v1[@]}; i++ )); do
        # Fill empty positions in v2 with zeros
        if [[ -z ${v2[i]} ]]; then
            v2[i]=0
        fi

        if (( 10#${v1[i]} < 10#${v2[i]} )); then
            return 1
        fi
    done
}

## TESTING LAUNCHCTL - START
launchctl_list_labels() {
    LAUNCHCTL_LIST='launchctl list | tail -n +2 | grep -v -e "0x[0-9a-fA-F]" | awk '{print $3}''
}

launchctl_list_started () {
    LAUNCHCTL_STARTED='launchctl list | tail -n +2 | grep -v "^-" | grep -v -e "0x[0-9a-fA-F]" | awk '{print $3}''
}

launchctl_list_stopped () {
    LAUNCHCTL_STOPPED='launchctl list | tail -n +2 | grep "^-" | grep -v -P "0x[0-9a-fA-F]" | awk '{print $3}''
}

funct_launchctl_check () {
    if [ "$os_name" = "Darwin" ]; then
        launchctl_service=$1
        required_status=$2
        log_file="$launchctl_service.log"
        if [ "$required_status" = "on" ] || [ "$required_status" = "enable" ]; then
            required_status="enabled"
            change_status="load"
        else
            required_status="disabled"
            change_status="unload"
        fi
        total=`expr $total + 1`
        check_value=`launchctl list |grep $launchctl_service |awk '{print $3}'`
        if [ "$check_value" = "$launchctl_service" ]; then
            actual_status="enabled"
        else
            actual_status="disabled"
        fi
        if [ "$audit_mode" != 2 ]; then
            echo "Checking:  Service $launchctl_service is $required_status"
            if [ "$actual_status" != "$required_status" ]; then
                insecure=`expr $insecure + 1`
                echo "Warning:   Service $launchctl_service is $actual_status [$insecure Warnings]"
                funct_verbose_message "" fix
                funct_verbose_message "sudo launchctl $change_status -w $launchctl_service.plist" fix
                funct_verbose_message "" fix
                if [ "$audit_mode" = 0 ]; then
                    log_file="$work_dir/$log_file"
                    echo "$actual_status" > $log_file
                    echo "Setting:   Service $launchctl_service to $required_status"
                    sudo launchctl $change_status -w $launchctl_service.plist
                fi
            else
                if [ "$audit_mode" = 1 ]; then
                    secure=`expr $secure + 1`
                    echo "Secure:    Service $launchctl_service is $required_status [$secure Passes]"
                fi
            fi
        else
            log_file="$restore_dir/$log_file"
        if [ -f "$log_file" ]; then
            restore_status=`cat $log_file`
            if [ "$restore_status" = "enabled" ]; then
                change_status="load"
            else
                change_status="unload"
            fi
            if [ "$restore_status" != "$actual_status" ]; then
                sudo launchctl $change_status -w $launchctl_service.plist
            fi
        fi
    fi
fi
}

## ----

function list() {
    { set +x; } 2>/dev/null
    ( set -x; launchctl list | grep sh.launchd )
}

function load() {
    { set +x; } 2>/dev/null
    ( set -x; launchctl load -w "$1" )
}

function unload() {
    { set +x; } 2>/dev/null
    ( set -x; launchctl unload -w "$1" )
}

function reload() {
    { set +x; } 2>/dev/null
    unload $@
    load $@
}

# .plist
function plist() {
    { set +x; } 2>/dev/null
    ( set -x; plutil -convert xml1 "$1" )
}

## TESTING LAUNCHCTL - END

## TESTING OTHER - START
check_server_ping() {
    ping -c 5 -W 2 -i 0.2 "${server}" &> /dev/null

    if [ $? -eq 0 ]
    then
        return 0
    else
        echo "Unable to ping the server specified, exiting"
        return 1
    fi
}

check_server_port() {  
    echo "" > /dev/tcp/${server}/${port}
    if [ $? -eq 0 ]
    then
        return 0
    else
        echo "Unable to connect to specified port \"${port}\" on the server ${server}, exiting"
        return 1
    fi
}

function variable_replace() {
    _variable="${1}"
    _replace="${2}"
    _file="${3}"
    _return_file"{4}"


    echo "$(cat "{_file}" | sed "s/\$(_variable)/\$(_replace)/g" > "${_return_file}")" 

    if [ ${rc} -eq 0 ]
    then
        return 0
    else
        return 1
    fi
}

## TESTING OTHER - END

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

install_dmg () {
    ## !! ERROR on find with volume having a space !! ##

    APPLICATION_FOLDER="/Applications"

    #echo "Mounting image..."
    volume=`hdiutil mount -nobrowse "$1" | tail -n1 | perl -nle '/(\/Volumes\/[^ ]+)/; print $1'`

    # Locate .app folder and move to /Applications
    app=`find $volume/. -name *.app -maxdepth 1 -type d -print0`

    #echo "Copying `echo $app | awk -F/ '{print $NF}'` into Application folder ..."
    echo "sudo cp -R $app $APPLICATION_FOLDER/"
    read -p "Press any key..."
    sudo cp -R $app $APPLICATION_FOLDER/

    return $?

    # Unmount volume, delete temporal file
    hdiutil unmount $volume -quiet
    #rm "$1"
}

print_error() {
    print_in_red "  [✖] $1 $2\n"
}

print_in_green() {
    printf "\e[0;32m$1\e[0m"
}

print_in_purple() {
    printf "\e[0;35m$1\e[0m"
}

print_in_red() {
    printf "\e[0;31m$1\e[0m"
}

print_in_yellow() {
    printf "\e[0;33m$1\e[0m"
}

print_info() {
    print_in_purple "\n $1\n\n"
}

print_question() {
    print_in_yellow "  [?] $1"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    return $1
}

print_success() {
    print_in_green "  [✔] $1\n"
}

verify_os() {
    declare -r MINIMUM_OS_X_VERSION='10.11'
    declare -r OS_NAME="$(uname -s)"

    declare OS_VERSION=''

    # Check if the OS is `OS X` and
    # it's above the required version
    if [ "$OS_NAME" == "Darwin" ]; then

        OS_VERSION="$(sw_vers -productVersion)"

        is_supported_version "$OS_VERSION" "$MINIMUM_OS_X_VERSION" \
            && return 0 \
            || printf "Sorry, this script is intended only for OS X $MINIMUM_OS_X_VERSION+"
    else
        printf 'Sorry, this script is intended only for OS X!'
    fi

    return 1
}
