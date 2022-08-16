#!/bin/bash
# Itamar Bachar 318781630
func () {
find . -type f -name "*.out" -delete
for f in *.c;
  do
      if grep -q -w  -i "$2" "$f";
      then
        gcc -w  -o "${f%.*}.out" "$f"
      fi
  done
for d in */;
  do
    if [[ -d $d ]];
    then
      cd $d
      func "$1" "$2" "$3"
      cd ..

      fi
  done
}


if [ -z "$2" ]
    then
      echo "Not enough parameters"
      exit 0
fi

if [[ "$3" == "-r" ]]
then
		cd $1
    func "$1" "$2" "$3"
  else
    cd $1
  find . -type f -name "*.out" -delete
    for f in *.c;
    do
        if grep -q -w  -i "$2" "$f";
        then
          gcc -w  -o "${f%.*}.out" "$f"
        fi
    done
  fi

