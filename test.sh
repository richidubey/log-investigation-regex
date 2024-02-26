pattern='.*\([[:digit:]]+\).*'
text="WCCOActrl (102), 2024"

if [[ $text =~ $pattern ]]; then
   echo Pass
else
    echo fail
fi