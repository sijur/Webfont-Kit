#!/usr/bin/env bash

SOURCE=$1
DESTINATION=$2
FILENAME=$(basename "${SOURCE%.ttf}")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# check if destination is defined or empty
if [[ -z $DESTINATION ]]; then
  echo "usage: convert_ttf requires a destination folder."
  echo "usage: webfonts input_file /path/to/output/"
  exit 1
fi

# check the destination is a folder
if [[ ! -d "$DESTINATION" ]]; then
  echo "creating folder ${DESTINATION}."
  mkdir $DESTINATION
fi

ALLCOMMANDS=(
#   mkeot
  ttf2eot
#   eot2ttf
  sfnt2woff
  woff2_compress
)

# ToDo: I need to sanitize the names, remove spaces, and replace with underscores (_).

# check which commands are installed, if not install them
if [[ ! -x "$SCRIPT_DIR/command_checker.sh" ]]; then
  echo "The script $SCRIPT_DIR/command_checker.sh is missing or not executable."
  exit 1
fi

/bin/bash "$SCRIPT_DIR/command_checker.sh" "${ALLCOMMANDS[@]}"

# TTF -> EOT
EOT_PATH="$DESTINATION/$FILENAME.eot"
echo "[TTF ---> EOT]: (over-)write to $EOT_PATH"
ttf2eot "${SOURCE}" "${EOT_PATH}"

# TTF -> WOFF
WOFF_PATH="$DESTINATION/$FILENAME.woff"
echo "[TTF ---> WOFF]: (over-)write to $WOFF_PATH"
sfnt2woff "${SOURCE}"
mv "$FILENAME.woff" "$WOFF_PATH"

# TTF -> WOFF2
WOFF2_PATH="$DESTINATION/$FILENAME.woff2"
echo "[TTF -> WOFF2]: (over-)write to $WOFF2_PATH"
woff2_compress "${SOURCE}" > "${WOFF2_PATH}"

# copy ttf file
TTF_PATH="$DESTINATION/$FILENAME.ttf"
cp "${SOURCE}" "${TTF_PATH}"

FONT_TXT_PATH="$DESTINATION/${DESTINATION//.\/}.txt"
FONT_FACE_DECLARATION="@font-face {
  font-family: \"$FILENAME\";
  src: url(\"$EOT_PATH\");
  src: url(\"$EOT_PATH?#iefix\")format(\"embedded-opentype\"),
  url(\"$WOFF2_PATH\")format(\"woff2\"),
  url(\"$WOFF_PATH\")format(\"woff\"),
  url(\"$TTF_PATH\")format(\"truetype\");
}"


if [[ -f $FONT_TXT_PATH ]]; then
  echo "TXT file exists"
  new_content=`cat $FONT_TXT_PATH`
  new_content+="\n\n"
  new_content+="$FONT_FACE_DECLARATION"
  echo -en "$new_content" > "$FONT_TXT_PATH"
else
  echo "Creating txt file."
  touch "$FONT_TXT_PATH"
  echo -en "$FONT_FACE_DECLARATION" > "$FONT_TXT_PATH"
fi

exit 0