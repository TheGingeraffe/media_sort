#!/bin/bash
# This script organizes images, videos, GIFs, and HTML files in the target directory.

# Sets and confirms directory to be operated on.

read -ep 'Directory to sort: ' pointer;
read -ep "Are you sure you would like to sort ${pointer}? (y/n): " confirmation;

# deletes trailing /
# needs "" and space after colon
if [[ "${pointer: -1}" == "/" ]]; then
pointer="${pointer::-1}"
fi

if [[ "${confirmation}" = y ]]; then
  echo "Sorting "${pointer}/sort"..."
else
  exit 1
fi

# Homogenize sort dir by moving files to top level

find "${pointer}/sort" -mindepth 2 -type f -exec mv -t "${pointer}/sort" {} +

# Changes whitespaces in filenames to underscores in preparation for the loop. 

find "${pointer}/sort" -type f -iname "* *" \
  | while read sort_file; do
  echo "Renaming ${sort_file}"
  mv "${sort_file}" "${sort_file// /_}"
  done

# Loop that iterates on a list of files found in $pointer and moves them to the 
# appropriate directories

md_sort () {
pointer="${1}"
destination="${2}"
file_type="${3}"

if ! [[ -d ${pointer}/${destination} ]]; then
mkdir -p ${pointer}/${destination}
fi

for thing in $(find ${pointer}/sort -maxdepth 1 -type f); do
  if [[ $(file ${thing} | cut -f2 -d":" | cut -f2 -d" ") == ${file_type} ]] && \
  ! [[ -f "${pointer}/${destination}/${thing}" ]]; then
    mv "${thing}" "${pointer}/${destination}"
    echo "${thing} has type ${destination}, moving to ${pointer}/${destination}"
  fi
done
}

md_sort ${pointer} 'img' '*[NEP]G'
md_sort ${pointer} 'gif' 'GIF'
md_sort ${pointer} 'vid' 'ISO'
md_sort ${pointer} 'vid' 'WebM'
md_sort ${pointer} 'html' 'HTML'