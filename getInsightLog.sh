filename=latest_pvssii.log

line1=$(head -n 1 $filename)
line2=$(head -n 2 $filename | tail -n 1)

pattern='.*\([[:digit:]]+\).*'
read -r line < $filename
# echo $line2

# echo $line

i=0
cSev=0
cInf=0
cWar=0

arr=()
while read line; do
    #echo $i is $line
    
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
            #echo i is greater than 0
            arr[$((i-1))]+=$line
        fi
    fi
    
    if [ "$i" -eq "150" ]; then
            break
    fi
    # echo End Message
    # echo ${arr[2]}
done < $filename

#echo "\n\n"

infArr=()
warArr=()
sevArr=()

infArrC=()
warArrC=()
sevArrC=()


for(( j=0; j<${#arr[@]};j++ )); do
    #echo $j : ${arr[j]} 
    ##At this point, we have all the log lines in a proper delimiter modifiable format.

        
    ######################## Delimit by , and save in an array
    IFS=',';

    delimitFinalArr=(${arr[j]});

    unset IFS;
    #############################################

    #echo $j : ${delimitFinalArr[0]}
    k=0
    for((; k<${#delimitFinalArr[@]};k++ )); do
        #echo $k: ${delimitFinalArr[k]} 
        :
    done

    patternInf=".*INFO.*"
    patternWar=".*WARNING.*"
    patternSev=".*SEVERE.*"

    msg=${delimitFinalArr[$((k-1))]}
    
    #echo "Message is " $msg


    #echo "Level is :" ${delimitFinalArr[3]}
    if [[ "${delimitFinalArr[3]}" =~ $patternInf ]]; then
        cInf=$((cInf+1))
        #echo "Matches INFO"

        flag=0
        for((s=0; s<${#infArr[@]};s++ )); do

            if [[ "${infArr[$s]}" == "$msg" ]]; then
                flag=1;
                infArrC[$s]=$((${infArrC[$s]}+1))
                break;
            fi

        done
        if [[ "$flag" -eq "0" ]]; then
            infArr+=("${delimitFinalArr[$((k-1))]}")
            infArrC+=("1")
        fi
    fi

    if [[ ${delimitFinalArr[3]} =~ $patternWar ]]; then
        cWar=$((cWar+1))
        #echo "Matches Warning"

        flag=0
        for((s=0; s<${#warArr[@]};s++ )); do

            if [[ "${warArr[$s]}" == "$msg" ]]; then
                flag=1;
                warArrC[$s]=$((${warArrC[$s]}+1))
                break;
            fi

        done
        if [[ "$flag" -eq "0" ]]; then
            warArr+=("${delimitFinalArr[$((k-1))]}")
            warArrC+=("1")
        fi
    fi

    if [[ ${delimitFinalArr[3]} =~ $patternSev ]]; then
        cSev=$((cSev+1))
        #echo "Matches Severity"
        
        flag=0
        for((s=0; s<${#sevArr[@]};s++ )); do

            if [[ "${sevArr[$s]}" == "$msg" ]]; then
                flag=1;
                sevArrC[$s]=$((${sevArrC[$s]}+1))
                break;
            fi

        done
        if [[ "$flag" -eq "0" ]]; then
            sevArr+=("${delimitFinalArr[$((k-1))]}")
            sevArrC+=("1")
        fi
    fi

    #echo "\n"

done
   #echo "\n"
echo "Info:" $cInf " Warning:" $cWar " Severe:" $cSev


##SHOW ALL##

################################################################
echo "\n"Severe Messages are

for(( s=0; s<${#sevArr[@]};s++ )); do
        echo ${sevArrC[s]} : ${sevArr[s]} 
done

echo "\n"Warning Messages are

for(( s=0; s<${#warArr[@]};s++ )); do
        echo ${warArrC[s]}: ${warArr[s]} 
done

echo "\n"Info Messages are

for(( s=0; s<${#infArr[@]};s++ )); do
        echo ${infArrC[s]}: ${infArr[s]} 
done
###################################################################



##Show Only gt 5##

################################################################

printf "\n\nShow Only gt 5##\n"
printf "\nSevere Messages are\n"

for(( s=0; s<${#sevArr[@]};s++ )); do
        if [[ ${sevArrC[s]} -gt "5" ]]; then
            echo ${sevArrC[s]} : ${sevArr[s]} 
        fi
done

printf "\nWarning Messages are\n"

for(( s=0; s<${#warArr[@]};s++ )); do
        if [[ ${warArrC[s]} -gt "5" ]]; then
            echo ${warArrC[s]}: ${warArr[s]} 
        fi
done

echo "\n"Info Messages are

for(( s=0; s<${#infArr[@]};s++ )); do
        if [[ ${infArrC[s]} -gt "5" ]]; then
            echo ${infArrC[s]}: ${infArr[s]} 
        fi
done
###################################################################







#fVar=${arr[117]}
# IFS=',';

# delimitArr=(${fVar});

# unset IFS;

# echo "\n117th String is" $fVar
# echo "0th delimited by , for 117the string is:  " ${delimitArr[0]}
# echo "1th delimited by , for 117the string is:  " ${delimitArr[1]}
# echo "2th delimited by , for 117the string is:  " ${delimitArr[2]}