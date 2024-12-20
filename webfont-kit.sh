#!/usr/bin/env bash

set -e

SOURCE=$1
DESTINATION=$2

type=${SOURCE: -4}

# we omit mime check since we use this script only locally and assume it's otf
if [[ ! "$type" =~ ^(".otf"|".ttf"|".eot"|"woff"|"off2")$ ]]; then
  echo "usage: convert_otf requires an OTF file."
  echo "usage: convert_otf input.otf /path/to/output/"
  exit 1
fi

if [[ $type == ".otf" ]]; then
  /bin/bash ~/bash_files/bash_scripts/Webfont-Kit/convert_otf.sh $SOURCE $DESTINATION
elif [[ $type == ".ttf" ]]; then
  /bin/bash ~/bash_files/bash_scripts/Webfont-Kit/convert_ttf.sh $SOURCE $DESTINATION
# elif [[ "$type" == ".eot" ]]; then
#   /bin/bash ./convert_eot.sh
# elif [[ ${SOURCE: -5} == ".woff" ]]; then
#   /bin/bash ./convert_woff.sh
# elif [[ ${SOURCE: -6} == ".woff2" ]]; then
#   /bin/bash convert_woff2.sh
else
  echo "I can only convert one of the following file types"
  echo '".otf", ".ttf", ".eot", ".woff", ".woff2"'
  exit 1
fi