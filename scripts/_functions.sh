#!/bin/bash

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

file_exist() {
    if [ -f "$1" ]; then
        return $?
    else
        return 1
    fi
}

folder_exist() {
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
    APPLICATION_FOLDER="/Applications"

    #echo "Mounting image..."
    volume=`hdiutil mount -nobrowse "$HOME/Downloads/${SABNZBD_DIR}-osx.dmg" | tail -n1 | perl -nle '/(\/Volumes\/[^ ]+)/; print $1'`

    # Locate .app folder and move to /Applications
    app=`find $volume/. -name *.app -maxdepth 1 -type d -print0`
    #echo "Copying `echo $app | awk -F/ '{print $NF}'` into Application folder ..."
    cp -R $app $APPLICATION_FOLDER
    return $?

    # Unmount volume, delete temporal file
    hdiutil unmount $volume -quiet
    rm "$HOME/Downloads/${SABNZBD_DIR}-osx.dmg"
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
