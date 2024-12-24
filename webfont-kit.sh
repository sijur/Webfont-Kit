#!/usr/bin/env bash

set -e
CUR_DIR=$(pwd)

source "$CUR_DIR/lib/error_exit.sh"

main() {
  # we omit mime check since we use this script only locally and assume it's otf

  if [[ $1 =~ \.(otf|ttf|eot|woff|woff2)$ ]]; then
    type=${BASH_REMATCH[1]}
  else
    msg="usage: webfont-kit requires a valid font file.
    Please provide an .otf, .ttf, .eot, .woff, or .woff2 file.
    usage: webfonts input_file /path/to/output/"
    error_exit "$msg"
  fi

  case $type in
    otf)
      echo "OTF file detected."
      if [[ -f "$CUR_DIR/lib/convert_otf.sh" ]]; then
        /bin/bash $CUR_DIR/lib/convert_otf.sh $1 $2
      else
        error_exit "The script $CUR_DIR/lib/convert_otf.sh is missing."
      fi
      ;;
    ttf)
      echo "TTF file detected."
      if [[ -f "$CUR_DIR/lib/convert_ttf.sh" ]]; then
        /bin/bash $CUR_DIR/lib/convert_ttf.sh $1 $2
      else
        error_exit "The script $CUR_DIR/lib/convert_ttf.sh is missing."
      fi
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
      msg="Unsupported file type: $type
      Please provide an .otf, .ttf, .eot, .woff, or .woff2 file."
      error_exit "$msg"
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi