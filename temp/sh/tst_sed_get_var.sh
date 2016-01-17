#!/bin/bash

# sabnzbd.ini
# api_key
# nzb_key

## Notes
#  http://serverfault.com/questions/419533/edit-a-file-via-bash-script


## Working
# sed -n -e '/^api_key/ s/.*\= *//p' sabnzbd.ini


function sedeasy {
    if [ $# -ne 3 ]; then
        echo "usage: sedasy CURRENT REPLACEMENT FILENAME"
        return
    fi
    sed -i "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed     -e 's/[\/&]/\\&/g')/g" $3
}

sed_replace_in_file() {
  if [ "$#" != 3 ]; then
    echo "Usage: greplace file_pattern search_pattern replacement"
    return 1
  else
    file_pattern=$1
    search_pattern=$2
    replacement=$3

    # This works with BSD grep and the sed bundled with OS X.
    # GNU grep takes `-Z` instead of `--null`.
    # Other versions of sed may not support the `-i ''` syntax.

    find . -name "$file_pattern" -exec grep -lw --null "$search_pattern" {} + |
    xargs -0 sed -i '' "s/[[:<:]]$search_pattern[[:>:]]/$replacement/g"
  fi
}

sed_find_var_in_file() {
	if [ "$#" != 2 ]; then
	    echo "Usage: sed_find_in_file file_name search_pattern"
	    return 1
	else
		file_name=$1
		search_pattern=$2
	    sed -n -e '/'$search_pattern'/ s/.*\= *//p' $file_name
	fi
}

#echo $(sed_find_var_in_file 'sabnzbd.ini' '^api_key')

echo $(sed_replace_in_file 'sabnzbd.ini' 'dir = ""' 'dir = "assd"')
