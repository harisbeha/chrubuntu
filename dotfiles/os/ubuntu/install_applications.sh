#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")" && source "../utils.sh"

declare -a APT_PACKAGES=(

    # Tools for compiling/building software from source
    "build-essential"
    "libsmbclient"
    "libxml2-dev"
    "libxslt-dev"
    "libpq-dev"
    "autotools"
    "autoconf"
    "exuberant-ctags"
    "neovim"
    "silversearcher-ag"

    # GnuPG archive keys of the Debian archive
    "debian-archive-keyring"

    # Software which is not included by default
    # in Ubuntu due to legal or copyright reasons
    #"ubuntu-restricted-extras"

    #Software for development
    "oracle-java7-installer"
    "virtualenv"
    "virtualenvwrapper"

    # Other
    "chromium-browser"
    "curl"
    "firefox-trunk"
    "flashplugin-installer"
    "gimp"
    "git"
    "google-chrome-stable"
    "imagemagick"
    "nodejs"
    "npm"
    "psql"
    "python-dev"
    "ruby"
    "sublime-text"
    "tree"
    "vim-nox"
    "xclip"

)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_key() {
    wget -qO - "$1" | sudo apt-key add - &> /dev/null
    #     │└─ write output to file
    #     └─ don't show output
}

add_ppa() {
    sudo add-apt-repository -y ppa:"$1" &> /dev/null
}

add_software_sources() {

    # Sublime
    [ $(cmd_exists "subl") -eq 1 ] \
        && add_ppa "webupd8team/sublime-text-2"

    #Java
    [ $(cmd_exists "java") -eq 1 ] \
        && add_ppa "webupd8team/java"

    # Firefox Nightly
    [ $(cmd_exists "firefox-trunk") -eq 1 ] \
        && add_ppa "ubuntu-mozilla-daily/ppa"

    # Google Chrome
    [ $(cmd_exists "google-chrome") -eq 1 ] \
        && add_key "https://dl-ssl.google.com/linux/linux_signing_key.pub" \
        && add_source_list \
                "http://dl.google.com/linux/deb/ stable main" \
                "google-chrome.list"

    # NodeJS
    [ $(cmd_exists "node") -eq 1 ] \
        && add_ppa "chris-lea/node.js"


}

add_source_list() {
    sudo sh -c "printf 'deb $1' >> '/etc/apt/sources.list.d/$2'"
}

install_package() {
    local q="${2:-$1}"

    if [ $(cmd_exists "$q") -eq 1 ]; then
        execute "sudo apt-get install --allow-unauthenticated -qqy $1" "$1"
        #                                      suppress output ─┘│
        #            assume "yes" as the answer to all prompts ──┘
    fi
}

remove_unneeded_packages() {

    # Remove packages that were automatically installed to satisfy
    # dependencies for other other packages and are no longer needed
    execute "sudo apt-get autoremove -qqy" "autoremove"

}

update_and_upgrade() {

    # Resynchronize the package index files from their sources
    execute "sudo apt-get update -qqy" "update"

    # Unstall the newest versions of all packages installed
    execute "sudo apt-get upgrade -qqy" "upgrade"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    local i=""

    add_software_sources
    update_and_upgrade

    printf "\n"

    for i in ${!APT_PACKAGES[*]}; do
        install_package "${APT_PACKAGES[$i]}"
    done

    printf "\n"

    update_and_upgrade
    remove_unneeded_packages

}

main