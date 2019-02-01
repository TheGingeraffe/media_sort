#!/bin/bash
# This script organizes images, videos, GIFs, and HTML files in the target directory.

# Sets and confirms directory to be operated on.

read -ep 'Directory to sort: ' POINTER;
read -ep "Are you sure you would like to sort $POINTER? (y/n): " CONFIRMATION;

# Tests for target directories in $POINTER and creates them if necessary.

if [[ $CONFIRMATION = y ]]; then
  if ! [[ -e $POINTER/{img,gif,vid,html} ]]; then
    mkdir -p $POINTER/{img,gif,vid,html} && \
    echo "Creating destination directories..."
  else
    echo "Sorting $POINTER..."
  fi
else
  echo "Exiting..." && \
  exit 1
fi

# Changes whitespaces in filenames to underscores in preparation for the loop. 

find $POINTER -maxdepth 1 -type f -name '* *' \
  | while read f; do
  echo "Renaming $f"
  mv "$f" "${f// /_}"
  done

# Loop that iterates on a list of files found in $POINTER and moves them to the 
# appropriate directories

for thing in $(find $POINTER -maxdepth 1 -type f); do
  if [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == *[NEP]G ]] && ! [[ -f $POINTER/img/$thing ]]; then
    mv $thing $POINTER/img && \
    echo "$thing is an image, moving to $POINTER/img"
  elif [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == GIF ]] && ! [[ -f $POINTER/gif/$thing ]]; then
    mv $thing $POINTER/gif && \
    echo "$thing is a gif, moving to $POINTER/gif"
  elif [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == ISO ]] && ! [[ -f $POINTER/vid/$thing ]]; then
    mv $thing $POINTER/vid && \
    echo "$thing is a video, moving to $POINTER/vid"
  elif [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == WebM ]] && ! [[ -f $POINTER/html/$thing ]]; then
    mv $thing $POINTER/vid && \
    echo "$thing is a video, moving to $POINTER/vid"
  elif [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == HTML ]] && ! [[ -f $POINTER/$thing ]]; then
    mv $thing $POINTER/html && \
    echo "$thing is an html file, moving to $POINTER/html"
  else
    echo "There is either a file with the same name as $thing in the destination, or I'm not sure of $thing's file type"
  fi
done
