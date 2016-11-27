#!/bin/bash
# http://stackoverflow.com/a/18539730

set -e 

i=1
s=1
dist="TheInternetsOwnBoy_TheStoryofAaronSwartz-HD.srt"

spinner()
{
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

declare -a arr
while read -r line 
do
    # If we find an empty line, then we increase the counter (i), 
    # set the flag (s) to one, and skip to the next line
    [[ $line == "" ]] && ((i++)) && s=1 && continue 

    # If the flag (s) is zero, then we are not in a new line of the block
    # so we set the value of the array to be the previous value concatenated
    # with the current line
    [[ $s == 0 ]] && arr[$i]="${arr[$i]}
$line" || { 
            # Otherwise we are in the first line of the block, so we set the value
            # of the array to the current line, and then we reset the flag (s) to zero 
            arr[$i]="$line"
            s=0; 
    }
done < src.txt

splitting()
{
  echo "" > $dist
  
  for i in "${arr[@]}"
  do
     lines=`echo "$i" | wc -l`
     lines=$((lines-2))
     index=`echo -e "$i" | head -n 2`
     if [ "$lines" -gt 3 ];then
       i=`echo -e "$i" | sed '3,5d'`
     elif [ "$lines" -gt 2 ];then
       i=`echo -e "$i" | sed '3,4d'`
     else 
       i=`echo -e "$i" | sed '3d'`
     fi
     i=`echo -e "$i" | sed '1,2d'`
     echo "$index" >> $dist
     echo "<font color=\"#ffff00\">$i</font>" >> $dist
     echo "" >> $dist
  done 
}

splitting & spinner
