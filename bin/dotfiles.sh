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

        help        This help message
        macos       Apply macOS system defaults
        update      Update package and package managers (OS, port, npm)
    "
}

sub_update() {
    # Update macOS App Store apps
    softwareupdate -i -a

    # Update MacPorts
    port selfupdate
    port upgrade outdated

    # Update npm
    npm install npm -g
    npm update -g
}

sub_macos() {
    defaults_file="${__dotfiles_dir}/.osxdefaults"
    echo "Applying ${defaults_file}" && source "${defaults_file}"
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
