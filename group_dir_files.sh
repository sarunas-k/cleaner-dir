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

get_input() {
	echo "Kaip išskirstyti šio aplanko failus? metai, mėnesiai, dienos" ; read -r workmode
	if [[ ! "$workmode" =~ ^(metai|mėnesiai|dienos)$ ]] ; then
		echo "Įveskite tinkamą reikšmę" ; get_input
	fi
}

names=$(find . -maxdepth 1 -type f -not -path '*/\.*' | paste -sd ",")
IFS=',' read -r -a array <<< "$names"

if [[ ${#array[@]} == 1 ]]; then echo "Aplanke nėra ką išskirstyti" ; exit ; fi 

get_input

if [[ $workmode == 'metai' ]] ; then cutlength=4
elif [[ $workmode == 'mėnesiai' ]] ; then cutlength=7
elif [[ $workmode == 'dienos' ]] ; then cutlength=10
else echo "Klaida"; exit ; fi

for f in "${array[@]}"
do 
	if [[ "$f" =~ ^.*\.sh$ ]] ; then continue ; fi

	stat=$(stat --format="%y" "$f")
	date=${stat:0:cutlength}
	if [ ! -d "$date" ] ; then mkdir $date ; fi

	mv "$f" "$date/$f"
done
echo "Užduotis baigta"

