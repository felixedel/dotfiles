#! /usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}")"
__dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

arg1="${1:-}"

error() { echo "-- [ERROR] ${*}" 1>&2 && false; }
info() { echo "-- [INFO] ${*}" 1>&2; }
warning() { echo "-- [WARNING] ${*}" 1>&2; }

print_help() {
    echo "Usage:

    ./${__base} <command>

    Commands:

        help            This help message
        macos           Apply macOS system defaults
        update [--osx]  Update package and package managers (port, npm)
                        Use the --osx flag to also update macOS.

    "
}

sub_update() {
    # The macOS update takes very long, even if there is nothing to update.
    # Thus, we make it optional
    if [ -n "${1:-}" ]; then
        read -p "The macOS update could take a while. Continue (y/n)? " yn
        case "${yn:0:1}" in
            y|Y)
                softwareupdate -i -a
                ;;
            *)
                echo "Skipping macOS update"
                ;;
        esac
    fi

    # Update MacPorts
    sudo port selfupdate
    sudo port upgrade outdated

    # Update npm
    npm install npm -g
    npm update -g
}

sub_macos() {
    defaults_file="${__dotfiles_dir}/.osxdefaults"
    echo "Applying ${defaults_file}" && source "${defaults_file}"
    echo "Some of the settings may require a relaunch of the finder application"
}

case ${arg1} in
    "" | "-h" | "--help")
        print_help
        ;;
    *)
        shift
        sub_${arg1} $@
        if [ $? = 127 ]; then
            error "'${arg1}' is not a known command."
            print_help
        fi
        ;;
esac
shift
