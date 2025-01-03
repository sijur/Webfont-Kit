#!/usr/bin/env bash

SOURCE=$1
DESTINATION=$2
FILENAME=$(basename "${SOURCE%.otf}")

# check if destination is defined or empty
if [[ -v DESTINATION && -z $DESTINATION ]]; then
  echo echo "usage: convert_otf requires a destination."
  echo "usage: convert_otf input.otf /path/to/output/"
  exit 1
fi

# check the destination is a folder
if [[ ! -d "$DESTINATION" ]]; then
  echo "creating folder ${DESTINATION}."
  mkdir $DESTINATION
fi

ALLCOMMANDS=(
  mkeot
  eot2ttf
  sfnt2woff
  woff2_compress
)

# ToDo: I need to sanitize the names, remove spaces, and replace with underscores (_).

# iterate the ALLCOMMANDS list to check for each required command
# skip as soon as a command is not found
for CMD in "${ALLCOMMANDS[@]}"
do
   :
   if [[ ! -f $(command -v "$CMD") ]];then
        echo "Cannot convert ($CMD). The following packages are required: eot-utils eot2ttf woff-tools woff2"
        exit 1
    fi
done

EOT_PATH="$DESTINATION/$FILENAME.eot"
echo "[OTF ---> EOT]: (over-)write to $EOT_PATH"
mkeot "${SOURCE}" > "${EOT_PATH}"

TTF_PATH="$DESTINATION/$FILENAME.ttf"
echo "[EOT ---> TTF]: (over-)write to $TTF_PATH"
eot2ttf "${EOT_PATH}" "${TTF_PATH}"

WOFF_PATH="$DESTINATION/$FILENAME.woff"
echo "[OTF --> WOFF]: (over-)write to $WOFF_PATH"
sfnt2woff "${SOURCE}"
mv "$FILENAME.woff" "$WOFF_PATH"

WOFF2_PATH="$DESTINATION/$FILENAME.woff2"
echo "[TTF -> WOFF2]: (over-)write to $WOFF2_PATH"
woff2_compress "${TTF_PATH}" > "${WOFF2_PATH}"


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
