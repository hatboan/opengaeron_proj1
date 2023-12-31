if [ $# -ne 3 ]; then
	echo "$0: args should be 3"
  exit 1
else
	echo "-----------------------"
	echo User Name: Lee Seung Min
	echo Student Number: 12181656
	echo [ MENU ]
	echo 1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
  echo 2. Get the data of 'action' genre movies from 'u.item'
  echo 3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'
  echo 4. Delete the 'IMDb URL' from 'u.item'
  echo 5. Get the data about users from 'u.user'
  echo 6. Modify the format of 'release date' in 'u.item'
  echo 7. Get the data of movies rated by a specific 'user id' from 'u.data'
  echo 8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
  echo  9. Exit
  echo "-----------------------"
  while true
  do
    read -p "Enter your choice [1-9] " choice
    case $choice in
      1)
	      read -p "Please enter 'movie id (1~1682): " movie_id
	      echo ""
        awk -v movie_id="$movie_id" -F'|' '$1 == movie_id { print $0}' "./$1"
        echo ""
        ;;
      2)
        read -p "Do you want to get the data of ‘action’ genre movies from 'u.item’?(y/n) : " yes
        if [ "$yes" = "y" ]
        then
          echo ""
          awk -v cnt=0 -F'|' '$7 == 1 && cnt<10 { print $1 " " $2; cnt++}' "./$1"
          echo ""
        fi
        ;;
      3)
        read -p "Please enter 'movie id (1~1682): " movie_id
        echo ""
        awk -v movie_id="$movie_id" -v cnt=0 -v sum=0 '$2 == movie_id { cnt++; sum+=$3 }  END { printf("average rating of %s: %.6g\n", movie_id, sum / cnt)}' "./$2"
        echo ""
        ;;
      4)
        read -p "Do you want to delete the ‘IMDb URL’ from ‘u.item’?(y/n) : " yes
        if [ "$yes" = "y" ]
        then
          echo ""
          sed -i "s/http[^|]*//g" "./$1"
          awk -v cnt=0 -F'|' 'cnt<10 { print $0; cnt++}' "./$1"
          echo ""
        fi
        ;;
      5)
        read -p "Do you want to get the data about users from ‘u.user’?(y/n) : " yes
        if [ "$yes" = "y" ]
        then
          echo ""
          sed -n -E -e "s/M/male/g; s/F/female/g; s/([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)/user \1 is \2 years old \3 \4/p; 10q" "./$3"
          echo ""
        fi
        ;;
      6)
        read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n) : " yes
        if [ "$yes" = "y" ]
        then
          echo ""
          sed -E -i "s/([0-9]{2})-([A-Za-z]{3})-([0-9]{4})/\3\2\1/g" "./$1"
          sed -E -i "s/Jan/01/g; s/Feb/02/g; s/Mar/03/g; s/Apr/04/g; s/May/05/g; s/Jun/06/g; s/Jul/07/g; s/Aug/08/g; s/Sep/09/g; s/Oct/10/g; s/Nov/11/g; s/Dec/12/g " "./$1"
          sed -n "1673,1682p" "./$1"
          echo ""
        fi
        ;;

      7)
        read -p "Please enter the 'user id' (1~943): " user_id
        echo ""
        awk -v user_id="$user_id"  '$1 == user_id {print $2}' "./$2" > seven.data
        sort -n <seven.data > seven_sort.data
        awk -v cnt=0 'cnt==1 {ORS=""; print "|" $0} cnt==0 {ORS=""; print $0; cnt++} END {ORS="\n\n";print "";}' seven_sort.data
        awk -F'|' -v cnt=0 'NR == FNR { values[$1] = 1; next } $1 in values&&cnt<10 {print $1 "|" $2; cnt++}' seven_sort.data "./$1"
        echo ""
        ;;
      8)
        read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) : " yes
        if [ "$yes" = "y" ]
        then
        echo ""
        awk -F'|' -v programmer="programmer" '$2>19 && $2<30 && $4==programmer {print $1}' "./$3" > eight.user
        awk 'NR == FNR { values[$1] = 1; next} $1 in values {print $0}' eight.user "./$2" > eight.data

        awk '{
          cnt[$2]++
          sum[$2] += $3
        }
        END {
          for (arg2 in sum) {
            if (cnt[arg2] > 0) {
              printf("%s %.06g\n", arg2, sum[arg2] / cnt[arg2])
            }
          }
        }' eight.data
        echo ""
        fi
        ;;
      9)
        echo Bye!
        exit
    esac
  done
fi
