#!/bin/bash
: '
The following script will list user information based on a supplied username.
User home directory, all processes that are running under the user, user files from /tmp and /home.
'

read -p "Specify a user: " nume
if [ $(id -u $nume 2>/dev/null || echo -1) -ge 0 ]; then
        echo "User found."
else
        echo "User is not part of the system."
fi

options=("dir_pers_user" "procs_user" "files_tmp_home" "UID_GID" "Exit")
select opt in "${options[@]}"
do
        case $opt in
                "dir_pers_user")
                echo "User's home directory: "
                eval echo ~$nume
                echo "Gata"
                ;;

                "procs_user")
                echo "$nume processes "
                ps -u $nume -U $nume
                echo "Done"
                ;;

                "files_tmp_home")
                echo "$nume files from /tmp and /home"
                find /tmp -type f -user $nume
                echo "==================================================="
                find /home -type f -user $nume
                echo "Done"
                ;;

                "UID_GID")
                echo "For all users, display UID:GID"
                cut -d: -f3,4 /etc/passwd
                echo "Done"
                ;;

                "Exit")
                break
                ;;

                *)
                echo "Invalid option"
                ;;
        esac
done
