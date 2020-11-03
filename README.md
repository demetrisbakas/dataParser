# dataParser
Bash script that parses data in a .dat file and answers queries 

> Run by using **./dataParser.sh** to get help

    HELP:
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
            changes the column of the specified reccord in the file to the value given


Your *.dat* input file should look like this:

    #id|firstName|lastName|gender|birthday|creationDate|locationIP|browserUsed
    1500|John|Becker|male|1980-11-08|2011-13-17T13:22:10.447+0000|192.267.3.653|Firefox