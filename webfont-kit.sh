#!/usr/bin/env bash

set -e

CUR_DIR=$(pwd)
# we omit mime check since we use this script only locally and assume it's otf

if [[ $1 =~ \.(otf|ttf|eot|woff|woff2)$ ]]; then
  type=${BASH_REMATCH[1]}
else
  echo "usage: webfont-kit requires a valid font file."
  echo "Please provide an .otf, .ttf, .eot, .woff, or .woff2 file."
  echo "usage: webfonts input_file /path/to/output/"
  exit 1
fi

case $type in
  otf)
    /bin/bash $CUR_DIR/lib/convert_otf.sh $1 $2
    ;;
  ttf)
    /bin/bash $CUR_DIR/lib/convert_ttf.sh $1 $2
    ;;
  # eot)
  #   /bin/bash $CUR_DIR/lib/convert_eot.sh $1 $2
  #   ;;
  # woff)
  #   /bin/bash $CUR_DIR/lib/convert_woff.sh $1 $2
  #   ;;
  # woff2)
  #   /bin/bash $CURR_DIR/lib/convert_woff2.sh $1 $2
  #   ;;
  *)
    echo "Unsupported file type: $type"
    echo "Please provide an .otf, .ttf, .eot, .woff, or .woff2 file."
    exit 1
    ;;
esac