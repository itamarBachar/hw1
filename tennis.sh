#!/bin/bash
# Itamar Bachar 318781630
player_1="50"
player_2="50"
player_2_guess=""
player_1_guess=""
game_on=true
last_move=" |       |       O       |       | "

moves=0

welcome_message() {
  echo " Player 1: ${player_1}         Player 2: ${player_2} "
  echo " --------------------------------- "
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo "$last_move"
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo " --------------------------------- "
}
print_board () {
  echo " Player 1: ${player_1}         Player 2: ${player_2} "
  echo " --------------------------------- "
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo "$last_move"
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo " --------------------------------- "
  echo "       Player 1 played: ${player_1_guess}"
  echo "       Player 2 played: ${player_2_guess}"
  echo ""
  echo ""
}

player_pick(){
   echo "PLAYER 1 PICK A NUMBER: "
  read -s player_1_guess
   if [[ ! $player_1_guess =~ ^[0-9]+$ ]]  || [[ $player_1_guess -gt $player_1 ]]
  then
    echo "NOT A VALID MOVE !"
    player_pick
  else
    player_1=$[$player_1-$player_1_guess]
    again
  fi
return;
}
again(){
   echo "PLAYER 2 PICK A NUMBER: "
  read -s player_2_guess
 if  [[ ! $player_2_guess =~ ^[0-9]+$  ]] || [[ $player_2_guess -gt $player_2 ]]
  then
    echo "NOT A VALID MOVE !"
    again
  else
    player_2=$[$player_2-$player_2_guess]
  fi
  return;
}


check_match() {
    case $moves in

  -3)
    last_move="O|       |       #       |       | "
    game_on=false
    ;;

  -2)
   last_move=" |   O   |       #       |       | "
    ;;

  -1)
    last_move=" |       |   O   #       |       | "
    ;;

  0)
    last_move=" |       |       O       |       | "
    ;;
  1)
    last_move=" |       |       #   O   |       | "
    ;;
  2)
    last_move=" |       |       #       |   O   | "
    ;;
  3)
    last_move=" |       |       #       |       |O"
    game_on=false
    ;;
esac
}

check_winner(){
  if [ $game_on == true ] && [[ $player_1_guess -gt $player_2_guess ]] && [[ $moves == 2 ]];
  then moves=3; 
  check_match;
  return;
  fi
  if [ $game_on == true ] && [[ $player_1_guess -gt $player_2_guess ]] && [[ $moves == 1 ]];
   then moves=2; 
   check_match;
   return;
  fi
  if [ $game_on == true ] && [[ $player_1_guess -gt $player_2_guess ]] && [[ 0 -ge $moves ]];
   then moves=1;   
   check_match;
   return;
  fi
  if [ $game_on == true ] && [[ $player_2_guess -eq $player_1_guess ]];
  then moves="$moves";
   check_match;
   return
  fi
  if [ $game_on == true ] && [[ $player_2_guess -gt $player_1_guess ]] && [[ $moves == -2 ]];
  then moves=-3;
  check_match;
  return;
  fi
  if [ $game_on == true ] && [[ $player_2_guess -gt $player_1_guess ]] && [[ $moves == -1 ]];
  then moves=-2;
  check_match;
  return;
   fi
  if [ $game_on == true ] && [[ $player_2_guess -gt $player_1_guess ]] && [[ $moves -ge 0 ]];
   then moves=-1;
    check_match;
    return;
  fi
  
}
check_if_end(){
if [[ $player_1 -eq 0 ]] && [[ $player_2 -eq 0 ]] ;
    then 
        if [[ $moves -gt  0 ]];
        then
            moves=3
            game_on=false 
            check_match
            return;    
        fi
        if [[ $moves -eq  0 ]];
        then
            moves=0 
            game_on=false 
            check_match
            return;    
        fi
        moves=-3
        game_on=false
        check_match 
        return;
    fi 
    if [[ $game_on == true ]] &&  [[ $player_1 -eq 0 ]] ;
    then 
        moves=-3
        game_on=false
        return
    fi 
    if [[ $game_on == true ]] && [[ $player_2 -eq 0 ]];
    then 
        moves=3
        game_on=false
        return
    fi
}


welcome_message
while $game_on
do
  player_pick
  check_winner
  print_board
  check_if_end
done
if [ $moves == 3 ];
then 
echo "PLAYER 1 WINS !";
fi
if [ $moves == -3 ];
then 
echo "PLAYER 2 WINS !";
fi
if [ $moves == 0 ];
then 
echo "IT'S A DRAW !"
fi
