#!/usr/bin/env bash

set -e
CUR_DIR=$(pwd)

source "$CUR_DIR/lib/error_exit.sh"

main() {
  SOURCE=$1 || error_exit "Please provide a valid source file."
  DESTINATION=$2 || error_exit "Please provide a valid destination folder."
  FILENAME=$(basename "${SOURCE%.ttf}") || error_exit "Please provide a valid source file."
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # check if destination is defined or empty
  if [[ -z $DESTINATION ]]; then
    msg="usage: convert_ttf requires a destination folder."
    msg+="\n"
    msg+="usage: webfonts input_file /path/to/output/"
    error_exit "$msg"
  fi

  # check the destination is a folder
  if [[ ! -d "$DESTINATION" ]]; then
    echo "creating folder ${DESTINATION}."
    mkdir $DESTINATION
  fi

  ALLCOMMANDS=(
    ttf2eot
    sfnt2woff
    woff2_compress
  )

  # ToDo: I need to sanitize the names, remove spaces, and replace with underscores (_).

  # check which commands are installed, if not install them
  if [[ -f "$SCRIPT_DIR/command_checker.sh" ]]; then
    /bin/bash "$SCRIPT_DIR/command_checker.sh" "${ALLCOMMANDS[@]}" || error_exit "Some commands are missing."
  else
    error_exit "The script $SCRIPT_DIR/command_checker.sh is missing."
  fi

  exit 1
  # # TTF -> EOT
  # EOT_PATH="$DESTINATION/$FILENAME.eot"
  # echo "[TTF ---> EOT]: (over-)write to $EOT_PATH"
  # ttf2eot "${SOURCE}" "${EOT_PATH}" || error_exit "Failed to convert TTF to EOT."

  # # TTF -> WOFF
  # WOFF_PATH="$DESTINATION/$FILENAME.woff"
  # echo "[TTF ---> WOFF]: (over-)write to $WOFF_PATH"
  # sfnt2woff "${SOURCE}" || error_exit "Failed to convert TTF to WOFF."
  # mv "$FILENAME.woff" "$WOFF_PATH"

  # # TTF -> WOFF2
  # WOFF2_PATH="$DESTINATION/$FILENAME.woff2"
  # echo "[TTF -> WOFF2]: (over-)write to $WOFF2_PATH" || error_exit "Failed to convert TTF to WOFF2."
  # woff2_compress "${SOURCE}" > "${WOFF2_PATH}"

  # OTF_PATH="$DESTINATION/$FILENAME.otf"
  # python3 ~/bash_files/bash_scripts/Webfont-Kit/convert_woff_2_otf.py "${WOFF_PATH}" "${OTF_PATH}" || error_exit "Failed to convert WOFF to OTF."

  # # copy ttf file
  # TTF_PATH="$DESTINATION/$FILENAME.ttf"
  # cp "${SOURCE}" "${TTF_PATH}"

  # FONT_TXT_PATH="$DESTINATION/${DESTINATION//.\/}.txt"
  # FONT_FACE_DECLARATION="@font-face {
  #   font-family: \"$FILENAME\";
  #   src: url(\"$EOT_PATH\");
  #   src: url(\"$EOT_PATH?#iefix\")format(\"embedded-opentype\"),
  #   url(\"$WOFF2_PATH\")format(\"woff2\"),
  #   url(\"$WOFF_PATH\")format(\"woff\"),
  #   url(\"$TTF_PATH\")format(\"truetype\");
  # }"


  # if [[ -f $FONT_TXT_PATH ]]; then
  #   echo "TXT file exists"
  #   new_content=`cat $FONT_TXT_PATH`
  #   new_content+="\n\n"
  #   new_content+="$FONT_FACE_DECLARATION"
  #   echo -en "$new_content" > "$FONT_TXT_PATH"
  # else
  #   echo "Creating txt file."
  #   touch "$FONT_TXT_PATH"
  #   echo -en "$FONT_FACE_DECLARATION" > "$FONT_TXT_PATH"
  # fi

  # exit 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi