# !bin/bash

declare -A matrix

score1=1
score2=1
winner=0	#it is used as a bool to control loop

#This function will show starting screen
function startingScreen()
{
   clear >$(tty)
   
   echo -ne '\033[01;34m          SNAKE AND LADDER GAME\n\033[00m'

   echo -ne "               LOADING"
   sleep 1  
   echo -n "."
   sleep 1  
   echo -n "."
   sleep 1  
   echo -ne "."
   sleep 1
   
   clear >$(tty)
}

#This functions will get names of players
function namesInput()
{
   echo -ne "\033[01;33mEnter Name Of Player 1 : "
   read player1
   
   echo -ne "\033[01;94mEnter Name Of Player 2 : "
   read player2
   
   echo -ne '\033[01;00m'
   
   clear >$(tty)
}

#This function will check if the player got ladder or not
function ladder()
{
   if [ $1 -eq 8 ] || [ $1 -eq 21 ] || [ $1 -eq 43 ] || [ $1 -eq 50 ] || [ $1 -eq 62 ] || [ $1 -eq 66 ] || [ $1 -eq 89 ]
   then
     echo -ne '\033[01;32mLadder!\n\033[00m'
     read -p "Press Any Key To Continue"
    fi
   
   if [ $1 -eq 8 ]
   then
     return 26
   
   elif [ $1 -eq 21 ]
   then
     return 82
   	
   elif [ $1 -eq 43 ]
   then
     return 77	
   	
   elif [ $1 -eq 50 ]
   then
        return 91
   	
   elif [ $1 -eq 62 ]
   then
        return 96
   	
   elif [ $1 -eq 66 ]
   then
        return 87
   	
   elif [ $1 -eq 89 ]
   then
        return 99
   else 
   	return $1   #returning the same value if player didnot get ladder
   fi
}

#This function will check if the player is bitten by snake or not
function snake()
{
   if [ $1 -eq 46 ] || [ $1 -eq 49 ] || [ $1 -eq 59 ] || [ $1 -eq 69 ] || [ $1 -eq 83 ] || [ $1 -eq 92 ] ||[ $1 -eq 98 ]
   then
     echo -ne '\033[01;31mSnake!\n\033[00m'
     read -p "Press Any Key To Continue"
    fi
   
   if [ $1 -eq 46 ]
   then
     return 5
   
   elif [ $1 -eq 49 ]
   then
    return 9
   	
   elif [ $1 -eq 59 ]
   then
     return 17	
   	
   elif [ $1 -eq 69 ]
   then
        return 33
   	
   elif [ $1 -eq 83 ]
   then
        return 19
   	
   elif [ $1 -eq 92 ]
   then
        return 51
   	
   elif [ $1 -eq 98 ]
   then
        return 28
   else 
   	return $1
   fi
}


#This function will calculate the scores of players
function scores()
{
   
   echo -e "\033[01;33m$player1 : $score1    \033[01;94m$player2 : $score2"
   
   echo -ne '\033[01;93m'
   
   #Score calculation of player1
   
   #generating random number 1 to 6
   dice=$(($RANDOM%6))
   dice=$(($dice+1))
   
   echo ""
   read -p "$player1 Press Any Key To Roll The Dice"
   
   echo "Dice Roll For $player1 = $dice"
   score1=$(( $dice + $score1 ))
   
   #if the score becomes greater than 100 the score will not be counted
   if [ $score1 -gt 100 ]
   then
      score1=$(( $score1 - $dice ))
   fi
   
   #calling ladder function to check if player got a ladder or not
   ladder $score1
   score1=$?
   #calling ladder function to check if player got a ladder or not
   snake $score1
   score1=$?

   #score calculation of player2
   echo""
   read -p "$player2 Press Any Key To Roll The Dice"
   
   
   dice=$(($RANDOM%6))
   dice=$(($dice+1))
   
   echo "Dice Roll For $player2 = $dice"
   score2=$(( $dice + $score2 ))
   
   if [ $score2 -gt 100 ]
   then
      score2=$(( $score2 - $dice ))
   fi
   
   echo -ne '\033[01;00m'
   
   ladder $score2
   score2=$?
   
   snake $score2
   score2=$?
   
   echo
}


#This function will print board and display positions of players
function Board()
{
   
   echo -e "\033[01;33m$player1 : $score1    \033[01;94m$player2 : $score2"
   echo -e '\033[01;00m'
   
   #Initializing array
   index=1  
   for((i=0;i<10;i++))
   {
     for((j=0;j<10;j++))
     {
       matrix[$i,$j]=$index
       index=$(($index+1))
     }
   }
   
   #displaying the board
   for ((i=0;i<10;i++))
   {
       for ((j=0;j<10;j++))
       {
          #displaying player's position
          if [ $score1 -eq ${matrix[$i,$j]} ] || [ $score2 -eq ${matrix[$i,$j]} ]
          then
          #if both players are at same position
            if [ $score1 -eq $score2 ]
            then
              echo -ne '\033[01;32mP1,P2  \033[00m'
             #displaying positions by p1 and p2
            elif [ $score1 -eq ${matrix[$i,$j]} ]
            then
      	      echo -ne '\033[01;33mP1   \033[00m'
            else
     	       echo -ne '\033[01;94mP2   \033[00m'
    	     fi
           else
              echo -n "${matrix[$i,$j]}  "
           fi
        }
        echo ""
    }

   echo ""
   #details of snakes and ladders
   echo -e "\033[01;91mSnakes: 98->28 | 92->51 | 83->19 | 69->33 | 59->17 | 49->9 | 46->5|"
   
   echo -e "\033[01;92mLadders: 8->26 | 21->82 | 43->77 | 50->91 | 62->96 | 66->87 |89->99|"

   echo -ne "\033[01;00m\n"
   
   #Announcing winner and ending game
   if [ $score1 -eq 100 ] || [ $score2 -eq 100 ]
   then
   
     if [ $score1 -eq 100 ]
     then
        echo -e "\033[01;96m$player1 Won The Game"
     
     elif [ $score2 -eq 100 ]
     then
        echo -e "\033[01;96m$player2 Won The Game"
     fi
     
     winner=1
     echo -e "\033[01;96mGAME OVER!\033[00m"
    
   else
   read -p "Press Any Key To Continue"
   clear >$(tty)
   scores  #calling score function to get scores
   fi
}


startingScreen
namesInput

while [ $winner -ne 1 ]
do
Board
done
