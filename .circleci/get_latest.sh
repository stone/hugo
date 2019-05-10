#!/bin/bash
tmpfile=$(mktemp)

function cleanup {
  rm -f "$tmpfile"
}
trap cleanup EXIT

curl -s "https://api.github.com/repos/gohugoio/hugo/releases/latest" > $tmpfile
#download_url=$(cat $tmpfile| jq -r '.assets[] | select(.name | contains("Linux-64bit.tar.gz") and (contains("extended")|not) )|.browser_download_url')
download_url=$(cat $tmpfile| jq -r '.assets[] | select(.name | contains("Linux-64bit.tar.gz") and (contains("extended")) )|.browser_download_url')
if [ $? -ne 0 ]; then
  exit 1
fi
hugo_version=$(cat $tmpfile|jq .name|sed 's/[^0-9\.]*//g')
if [ $? -ne 0 ]; then
  exit 1
fi

hugo_major_version=$(echo $hugo_version | cut -d .  -f1-2)

echo "================ $0 ================"     1>&2
echo "Hugo latest version: $hugo_version"       1>&2
echo "Hugo major version: $hugo_major_version"  1>&2
echo "URL: $download_url"                       1>&2
echo "====================================="    1>&2


echo -n "--build-arg HUGO_VERSION=$hugo_version --build-arg HUGO_DOWNLOAD_URL=$download_url -t fsteen/hugo:$hugo_version -t fsteen/hugo:$hugo_major_version"


