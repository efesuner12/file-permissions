#!bin/bash

EXTENSION_ARRAY=('pdf' 'xlsx' 'pptx' 'docx' 'txt' 'py' 'java' 'class' 'c' 'cpp' 'jpg' 'JPG' 'gif' 'png' 
'jfif' 'mp4' 'mp3' 'm3u' 'wma' 'asd' 'exe' 'sh' 'ps1' 'zip' 'sql' 'mwb')

function indexOf()
{
    lookForVal=$1

    for ((i=0; i<$pathsLen; i++));
    do
        if [[ $lookForVal == ${paths[${i}]} ]];
        then
            return $i
        fi
    done
}

function validPath()
{
    printf "\n[+] Checking the if the path is valid...\n"

    if [[ -d $1 ]];
    then
        printf "Done.\n"
        return 0
    fi

    printf "Not a valid directory path!\n\n"
    return 1
}

function changeDirPerm()
{
    item=$1

    printf "\n[+] Directory detected!"
    printf "\n[+] Adding read/write/execute access to all and removing write/execute from the world..."

    chmod a+rwx $item
    chmod o-wx $item

    printf "\nDone.\n"
}

function changeFilePerm()
{
    item=$1

    printf "\n[+] File detected!"
    printf "\n[+] Adding read/write access to all and removing write/execute from the world..."

    chmod a-x $item
    chmod a+rw $item
    chmod o-w $item

    printf "\nDone.\n"
}

function changeJarPerm()
{
    item=$1

    printf "\n[+] .jar file detected!"
    printf "\n[+] Adding read/write/execute access to all and removing write/execute from the world..."

    chmod a+rwx $item
    chmod o-wx $item

    printf "\nDone.\n"
}

isValid=1

while [ $isValid != 0 ]
do
    read -p "Please enter the master directory: " path
    validPath $path
    isValid=$?
done

printf "\n[+] Starting the algorithm...\n"

IFS=$'\n'
paths=($(find $path))
unset IFS

pathsLen=${#paths[@]}

for item in "${paths[@]}"
do
    if [[ $item != '' ]];
    then
        if [[ -d $item ]];
        then
            printf "\n${item}"
            
            changeDirPerm $item

            indexOf $item
            index=$?
            unset 'paths[$index]'
        else
            if [[ -f $item ]];
            then
                printf "\n${item}"

                filename=$(basename "$item")
                extension=${filename##*.}

                len=${#EXTENSION_ARRAY[@]}
                for ((i=0; i<$len; i++));
                do
                    if [[ $extension == ${EXTENSION_ARRAY[${i}]} ]];
                    then
                        changeFilePerm $item
                    else
                        if [[ $extension == "jar" ]];
                        then
                            changeJarPerm $item
                        fi
                    fi
                done
                
                indexOf $item
                index=$?
                unset 'paths[$index]'
            fi
        fi
    fi
done
