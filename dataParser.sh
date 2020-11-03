#!/bin/bash

# ./dataParser.sh
if [ $# = 0 ]; then
  echo "HELP:
    -f <file>
        input a .dat file

    -id <id>
        print the record with the given id if it exists

    --firstnames
        sorts by firstname and deletes duplicates

    --lastnames
        sorts by lastname and deletes duplicates

    --born-since <dateA>
        finds records with birthdate larger than the given one

    --born-until <dateA>
        finds records with birthdate smaller than the given one

    --browsers
        sorts by browser and removes duplicates

    --edit <id> <column> <value>
        changes the column of the specified reccord in the file to the value given"
  exit
fi

# sum is the number of variables
# del indicated delimiter, for example delF is "-f"
# The rest of the variables hold the position of the specified argument if that exists
# value holds the value given by the user 
i=0; let sum=$#; delF=0; delId=0; firstnames=0; lastnames=0; delBs=0; bornSince=0; delBu=0; bornUntil=0; delBrow=0; delEdit=0; column=0; value=0
# Parse input and determine arguments
while [ $i -le $sum ]; do
  if [ ${!i} = "-f" ]; then
    delF=$i
    let file=$delF+1
  elif [ ${!i} = "-id" ]; then
    delId=$i
    let id=$delId+1
    let id=${!id}
  elif [ ${!i} = "--firstnames" ]; then
    let firstnames=$i+1
  elif [ ${!i} = "--lastnames" ]; then
    let lastnames=$i+1
  elif [ ${!i} = "--born-since" ]; then
    delBs=$i
    let bornSince=$delBs+1
  elif [ ${!i} = "--born-until" ]; then
    delBu=$i
    let bornUntil=$delBu+1
  elif [ ${!i} = "--browsers" ]; then
    delBrow=$i
  elif [ ${!i} = "--edit" ]; then
    delEdit=$i
    let id=$delEdit+1
    let id=${!id}
    let column=$delEdit+2
    let column=${!column}
    let value=$delEdit+3
    value=${!value}
  fi
  let i++
done


# ./dataParser.sh -f <file>
if [ $delF -gt 0 -a $delId = 0 -a $firstnames = 0 -a $lastnames = 0 -a $delBs = 0 -a $delBu = 0 -a $delBrow = 0 -a $delEdit = 0 ]; then
  # Prints the whole file
  awk '!/^#/ {print $0}' ${!file}
  
# ./dataParser.sh -f <file> -id <id>
elif [ $delF -gt 0 -a $delId -gt 0 ]; then
  # Print the record with the given id if it exists
  awk -v var="$id" -F "|" '!/^#/ {if ($1 == var) print $2,$3,$5}' ${!file}
  
# ./dataParser.sh --firstnames -f <file>
elif [ $delF -gt 0 -a $firstnames -gt 0 ]; then
  # Sort by firstname and delete duplicates
  awk -F "|" '!/^#/ {print $2}' ${!file} | sort | uniq
  
# ./dataParser.sh --lastnames -f <file>
elif [ $delF -gt 0 -a $lastnames -gt 0 ]; then
  # Sort by lastname and delete duplicates
  awk -F "|" '!/^#/ {print $3}' ${!file} | sort | uniq

# ./dataParser.sh --born-since <dateA> --born-until <dateB> -f <file>
elif [ $delF -gt 0 -a $delBs -gt 0 -a $delBu -gt 0 ]; then
  dateSince=${!bornSince}
  dateUntil=${!bornUntil}
  
  # Check if the input is valid and print the corresponding record
  awk -v varSince="$dateSince" -v varUntil="$dateUntil" -F "|" '!/^#/ {if ((varSince <= $5) && (varUntil >= $5)) print}' ${!file}
  
# ./dataParser.sh --born-since <dateA> -f <file>
elif [ $delF -gt 0 -a $delBs -gt 0 -a $delBu = 0 ]; then
  dateSince=${!bornSince}
  
  # Check if the birth date is valid and print the correponding record
  awk -v varSince="$dateSince" -F "|" '!/^#/ {if (varSince <= $5) print}' ${!file}
  
# ./dataParser.sh --born-until <dateA> -f <file>
elif [ $delF -gt 0 -a $delBs = 0 -a $delBu -gt 0 ]; then
  dateUntil=${!bornUntil}
  
  # Check if the birth date is valid and print the correponding record
  awk -v varUntil="$dateUntil" -F "|" '!/^#/ {if (varUntil >= $5) print}' ${!file}

# ./dataParser.sh --browsers -f <file>
elif [ $delF -gt 0 -a $delBrow -gt 0 ]; then
  # Sort and remove duplicates
  awk -F "|" '!/^#/ {print $8}' ${!file} | sort | uniq -c | awk '{printf $2}; {if ($3 != "") printf " " $3}; {print " " $1}'
  
# ./dataParser.sh -f <file> --edit <id> <column> <value>
elif [ $delF -gt 0 -a $delEdit -gt 0 ]; then
  # Check if the column is between 2 and 8
  if [ $column -ge 2 -a $column -le 8 ]; then
    # Change the specified record in the given file if it exists
    awk -v OFS="|" -v var="$id" -v col="$column" -v val="$value" -v fileName="${!file}" -F "|" '!/^#/ {if ($1 == var) $col=val}; {print > fileName}' ${!file}
    
  fi
fi