#!/bin/bash


BASE_URL="https://releases.hashicorp.com"
DOWNLOAD_DIR=$HOME/Downloads
BIN_DIR=$HOME/bin

check_installed_version(){
    installed_version=$($1 version | head -n1 | awk '{if ($2 ~ /v.*/){print $2}else{print $NF}}' | tr -d 'v')
    echo "$installed_version"
}

check_latest_version(){
     latest_version=$(curl -s ${BASE_URL}/$1/ | xmllint --html --xpath '//body/ul/li[2]/a/text()' - 2>/dev/null | cut -d_ -f2)
     echo "$latest_version"
}

download() {
    ARTIFACT="${1}_${2}_darwin_amd64.zip"
    echo -n "Downloading $ARTIFACT ... "
    curl -sL ${BASE_URL}/$1/$2/$ARTIFACT -o $DOWNLOAD_DIR/$ARTIFACT
    echo "DONE"
}

install() {
    ARTIFACT="${1}_${2}_darwin_amd64.zip"
    echo -n "Installing $ARTIFACT ... "
    rm -f $BIN_DIR/$1
    unzip -qq $DOWNLOAD_DIR/$ARTIFACT -d $BIN_DIR
    chmod 755 $BIN_DIR/$1
    echo "DONE"
}

upgrade() {
    for p in $PRODUCT;do
        installed=$(check_installed_version $p)
        latest=$(check_latest_version $p)
        if [[ "$installed" == "$latest" ]];then
            echo "$p is already the latest version"
        else
            echo "Upgrading $p (installed: $installed, latest: $latest)"
            download $p $latest
            install $p $latest
        fi
    done
}

usage(){
    cat <<OUT
$(basename $0): a simple shell script to download the latest version of the named hashicorp utility

Usage: 
    $(basename $0) [-hdv] [all|consul|nomad|packer|terraform|vault]

Options:
    -h          This help output
OUT
exit 1
}

##############################################################################
# Main
##############################################################################
while getopts ":h" opt; do
  case $opt in
    h) usage;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
  esac
done

if [[ "$1" =~ ^(consul|nomad|packer|terraform|vault)$ ]]; then
    PRODUCT=$1
elif [[ "$1" =~ ^(all)$ ]]; then
    PRODUCT="consul nomad packer terraform vault"
else
    echo "$1 is not in the list of approved HashiCorp products"
    exit 1
fi

upgrade
