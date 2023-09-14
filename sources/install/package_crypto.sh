#!/bin/bash
# Author: The Exegol Project

source common.sh

function install_tls-map() {
    colorecho "Installing TLS map"
    rvm use 3.0.0@tls-map --create
    gem install tls-map
    rvm use 3.0.0@default
    add-aliases tls-map
    add-history tls-map
    add-test-command "tls-map --help"
    add-to-list "tls-map,https://github.com/sec-it/tls-map,tls-map is a library for mapping TLS cipher algorithm names."
}

function install_rsactftool() {
    colorecho "Installing Rsactftool"
    # This tool uses z3solver, which is very long to build (5 min)
    fapt libmpc-dev
    git -C /opt/tools clone --depth 1 https://github.com/RsaCtfTool/RsaCtfTool
    cd /opt/tools/RsaCtfTool
    python3 -m venv ./venv
    catch_and_retry ./venv/bin/python3 -m pip install -r requirements.txt
    add-aliases rsactftool
    add-history rsactftool
    add-test-command "rsactftool --help"
    add-to-list "rsactftool,https://github.com/RsaCtfTool/RsaCtfTool,The rsactftool tool is used for RSA cryptographic operations and analysis."
}

function install_rsacracker() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing RsaCracker"
    source "$HOME/.cargo/env"
    cargo install rsacracker
    add-history rsacracker
    add-test-command "rsacracker --help"
    add-to-list "RsaCracker,https://github.com/skyf0l/RsaCracker,Powerful RSA cracker for CTFs. Supports RSA - X509 - OPENSSH in PEM and DER formats."
}

# Package dedicated to attack crypto
function package_crypto() {
    set_ruby_env
    install_rsactftool              # attack rsa
    install_tls-map                 # CLI & library for mapping TLS cipher algorithm names: IANA, OpenSSL, GnuTLS, NSS
    install_rsacracker              # Powerful RSA cracker for CTFs. Supports RSA, X509, OPENSSH in PEM and DER formats.
}
