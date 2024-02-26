filename=PVSS_II.log

line1=$(head -n 1 $filename)
line2=$(head -n 2 $filename | tail -n 1)

pattern='.*\([[:digit:]]+\).*'
read -r line < $filename
# echo $line2

# echo $line

i=0

arr=()
while read line; do
    echo $i is $line
    

    
    ######################## Delimit by , and save in an array
    IFS=',';

    delimitArr=(${line});

    unset IFS;
    #############################################

    
    #echo "Checking regex for string: " ${delimitArr[0]} 
    if [[ "${delimitArr[0]}" =~ $pattern ]]; then
        arr+=("$line")
        i=$((i+1))
    else
        if [ "$i" -gt "0" ]; then
            echo i is greater than 0
            arr[$((i-1))]+=$line
        fi
    fi
    
    if [ "$i" -eq "150" ]; then
            break
    fi
    # echo End Message
    # echo ${arr[2]}
done < $filename

echo "\n\n"
for(( j=0; j<${#arr[@]};j++ )); do
    echo $j : ${arr[j]} 
    ##At this point, we have all the log lines in a proper delimiter modifiable format.

        
    ######################## Delimit by , and save in an array
    IFS=',';

    delimitFinalArr=(${arr[j]});

    unset IFS;
    #############################################

    echo $j : ${delimitFinalArr[0]}


done

# fVar=${arr[117]}
# IFS=',';

# delimitArr=(${fVar});

# unset IFS;

# echo "\n117th String is" $fVar
# echo "0th delimited by , for 117the string is:  " ${delimitArr[0]}
# echo "1th delimited by , for 117the string is:  " ${delimitArr[1]}
# echo "2th delimited by , for 117the string is:  " ${delimitArr[2]}