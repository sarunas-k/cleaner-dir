#!/bin/sh
# =~ 			tikrinti string pagal regex
# read -r name	ivesti teksto eilute i kintamaji name
#				-a ivesti array atskyrimas tarpai
# find .		gauti failų ir aplankų pavadinimus.
#				-maxdepth Tiek gilyn į aplankus eiti
#				-f TIK failai
#				-d TIK aplankai
#				-path "*string*" ieškoti, kad pathe būtų toks stringas
# stat "path"	gauti failo properties
#				--format "%y" įrašymo data
# mkdir "path"	padaryti aplanką
# mv "x" "oo/x"	keisti pavadinimą, perdėti į kitą aplanką
workmode=""
workmode_arg=""
get_input() {

	echo "Pagal kokį kriterijų suskirstyti failus? Galimi kriterijai: 1) tipas 2) data"
    while [[ ! "$workmode" =~ ^(tipas|data)$ ]]; do
        read -r workmode
        if [[ ! "$workmode" =~ ^(tipas|data)$ ]] ; then
            echo "Įveskite tinkamą reikšmę" ;
        fi
    done

    if [[ $workmode == "data" ]]; then
        echo "Pasirinkite sugrupavimo būdą: 1) metai 2) mėnesiai ar 3) dienos"
        while [[ ! "$workmode_arg" =~ ^(metai|mėnesiai|dienos)$ ]]; do
            read -r workmode_arg
            if [[ ! "$workmode_arg" =~ ^(metai|mėnesiai|dienos)$ ]] ; then
                echo "Įveskite tinkamą reikšmę" ; read -r workmode_arg
            fi
        done
    fi
}

group_by_date() {
    arg_linksnis=""

    if [[ $2 == "metai" ]] ; then cutlength=4; arg_linksnis="metus"
    elif [[ $2 == "mėnesiai" ]] ; then cutlength=7; arg_linksnis="mėnesį"
    elif [[ $2 == "dienos" ]] ; then cutlength=10; arg_linksnis="dieną"
    else echo "Klaida"; exit ; fi

    echo "Grupuojama pagal failo sukūrimo $arg_linksnis"

    local -n files_array=filenames
    for f in "${files_array[@]}"
    do
        if [[ "$f" =~ ^.*\.sh$ ]] ; then continue ; fi

        stat=$(stat --format="%y" "$f")
        date=${stat:0:cutlength}
        if [ ! -d "$date" ] ; then mkdir $date ; fi

        mv "$f" "$date/$f"
    done
    echo "Užduotis baigta"
}

group_by_type() {
    echo "Grupuojama pagal failo pobūdį"
    local -n files_array=filenames
    for f in "${files_array[@]}"
    do
        if [[ "$f" =~ ^.*\.sh$ ]] ; then continue ; fi

        ext="${f##*.}"
        type=$(file -b "$f")
        mime_type=$(file -i "$f")
        if [[ "$ext" =~ (exe|msi|msp|msu|inf|dmg|pkg|bin|deb|rpm|apk|ipa)$ ]]; then
            if [ ! -d "Programos" ] ; then mkdir "Programos" ; fi
            mv "$f" "Programos/$f"
        elif [[ "$type" =~ (document|text) ]] || [[ "$mime_type" =~ (document|text) ]]; then
            if [ ! -d "Tekstai ir dokumentai" ] ; then mkdir "Tekstai ir dokumentai" ; fi
            mv "$f" "Tekstai ir dokumentai/$f"
        elif [[ "$type" =~ image ]]; then
            if [ ! -d "Vaizdai" ] ; then mkdir "Vaizdai" ; fi
            mv "$f" "Vaizdai/$f"
        elif [[ "$type" =~ audio ]] || [[ "$ext" =~ (mp3|m4a|wav|flac|aac|alac|ogg|aiff|dsd)$ ]]; then
            if [ ! -d "Audio" ] ; then mkdir "Audio" ; fi
            mv "$f" "Audio/$f"
        elif [[ "$type" =~ media ]]; then
            if [ ! -d "Video" ] ; then mkdir "Video" ; fi
            mv "$f" "Video/$f"
        elif [[ "$type" =~ archive ]]; then
            if [ ! -d "Archyvai" ] ; then mkdir "Archyvai" ; fi
            mv "$f" "Archyvai/$f"
        else
            if [ ! -d "Kiti failai" ] ; then mkdir "Kiti failai" ; fi
            mv "$f" "Kiti failai/$f"
        fi
    done
    echo "Užduotis baigta"
}

names=$(find . -maxdepth 1 -type f -not -path "*/\.*" | paste -sd ",")
IFS="," read -r -a filenames <<< "$names"

if [[ ${#filenames[@]} == 1 ]]; then echo "Aplanke nėra ką išskirstyti" ; exit ; fi

get_input

if [[ $workmode == "data" ]]; then
    group_by_date "$filenames" "$workmode_arg"
else
    group_by_type "$filenames"
fi
