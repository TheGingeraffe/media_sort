#!/bin/bash
# Sets and moves to the directory to be operated on.

read -ep 'Path: ' POINTER;

if [[ $POINTER = /cydrive/f/n/* ]]; then 
  cd $POINTER
else 
  echo "Not here you don't, only to be run from F:/n/" && exit 1
fi

# Changes whitespaces in filenames to underscores in preparation for the loop. 

for f in $(find . -maxdepth 1 -type f); do
  mv "$f" "${f// /_}" 2>/dev/null 
done

# Loop that iterates on a list of files at maxdepth 1 in $POINTER and moves them to the 
# appropriate directories

for bleh in $(find . -maxdepth 1 -type f); do
  nameoffile=$(echo $bleh | cut -f2 -d"/")
  if [[ $(file $bleh | cut -f2 -d":" | cut -f2 -d" ") == *[NEP]G ]] && ! [[ -f /cygdrive/f/n/img/$nameoffile ]]; then
    mv $bleh /cygdrive/f/n/img && \
    echo "$nameoffile is an image, moving to /cygdrive/f/n/img"
  elif [[ $(file $bleh | cut -f2 -d":" | cut -f2 -d" ") == GIF ]] && ! [[ -f /cygdrive/f/n/gif/$nameoffile ]]; then
    mv $bleh /cygdrive/f/n/gif && \
    echo "$nameoffile is a gif, moving to /cygdrive/f/n/gif"
  elif [[ $(file $bleh | cut -f2 -d":" | cut -f2 -d" ") == ISO ]] && ! [[ -f /cygdrive/f/n/vid/$nameoffile ]]; then
    mv $bleh /cygdrive/f/n/vid && \ 
    echo "$nameoffile is a video, moving to /cygdrive/f/n/vid"
  elif [[ $(file $bleh | cut -f2 -d":" | cut -f2 -d" ") == WebM ]] && ! [[ -f /cygdrive/f/n/vid/$nameoffile ]]; then
    mv $bleh /cygdrive/f/n/vid && \
    echo "$nameoffile is a video, moving to /cygdrive/f//n/vid"
  elif [[ $(file $bleh | cut -f2 -d":" | cut -f2 -d" ") == HTML ]] && ! [[ -f /cygdrive/f/n/html/$nameoffile ]]; then
    mv $bleh /cygdrive/f/n/html && \
    echo "$nameoffile is an html file, moving to /cygdrive/n/html"
  else
    echo "There is either a file with the same name as $nameoffile in the destination, or I'm not sure of $nameoffile's file type"
  fi
done
