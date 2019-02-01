#!/bin/bash
# Sets and moves to the directory to be operated on.

read -ep 'Directory to sort: ' POINTER;
read -ep "Are you sure you would like to sort $POINTER? (y/n): " CONFIRMATION;

if [[ $CONFIRMATION = y ]]; then
  cd $POINTER && \
  echo "Moving to $POINTER"
else
  echo "Exiting.." && \
  exit 1
fi

# Changes whitespaces in filenames to underscores in preparation for the loop. 

find $POINTER -maxdepth 1 -type f \
  | while read f; do 
  mv "$f" "${f// /_}"
done

# Loop that iterates on a list of files found above and moves them to the 
# appropriate directories

for thing in $(find $POINTER -maxdepth 1 -type f); do
  nameoffile=$(echo $thing | cut -f2 -d"/")
  if [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == *[NEP]G ]] && ! [[ -f $POINTER/img/$nameoffile ]]; then
    mv $thing $POINTER/img && \
    echo "$nameoffile is an image, moving to $POINTER/img"
  elif [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == GIF ]] && ! [[ -f $POINTER/gif/$nameoffile ]]; then
    mv $thing $POINTER/gif && \
    echo "$nameoffile is a gif, moving to $POINTER/gif"
  elif [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == ISO ]] && ! [[ -f $POINTER/vid/$nameoffile ]]; then
    mv $thing $POINTER/vid && \ 
    echo "$nameoffile is a video, moving to $POINTER/vid"
  elif [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == WebM ]] && ! [[ -f $POINTER/html/$nameoffile ]]; then
    mv $thing $POINTER/vid && \
    echo "$nameoffile is a video, moving to $POINTER/vid"
  elif [[ $(file $thing | cut -f2 -d":" | cut -f2 -d" ") == HTML ]] && ! [[ -f $POINTER/$nameoffile ]]; then
    mv $thing $POINTER/html && \
    echo "$nameoffile is an html file, moving to $POINTER/html"
  else
    echo "There is either a file with the same name as $nameoffile in the destination, or I'm not sure of $nameoffile's file type"
  fi
done
