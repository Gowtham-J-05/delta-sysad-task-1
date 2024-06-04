#!/bin/bash
setupfunc ()
{
    sudo groupadd core_grp
    sudo groupadd mentors_grp
    sudo groupadd mentees_grp
    sudo useradd -m -g core_grp core
    sudo setfacl -m g:sudo:rwx /home/core
    cd /home/core
    mkdir mentees mentors
    cd mentors
    mkdir Webdev Appdev Sysad
    cp ~/$3 /home/core
    sudo chmod 711 /home/core
    sudo chmod 701 /home/core/mentees
    sudo chmod 700 /home/core/mentors
    sudo chmod 704 /home/core/mentors/Appdev
    sudo chmod 704 /home/core/mentors/Webdev
    sudo chmod 704 /home/core/mentors/Sysad
    sudo setfacl -m u:core:rwx /home/core/mentees
    sudo setfacl -m u:core:rwx /home/core/mentors
    sudo setfacl -m u:core:rwx /home/core/mentors/Appdev
    sudo setfacl -m u:core:rwx /home/core/mentors/Webdev
    sudo setfacl -m u:core:rwx /home/core/mentors/Sysad
    sudo chown core:core_grp /home/core/$3
    sudo chmod 700 /home/core/$3
    sudo setfacl -m g:sudo:rwx /home/core/$3
    mentee_list=$(grep -v ^Name $2 | cut -d ' ' -f 1)
    for mentee in $mentee_list
    do 
        sudo useradd -m -d /home/core/mentees/$mentee -g mentees_grp $mentee
        sudo setfacl -m g:sudo:rwx /home/core/mentees/$mentee
        cd /home/core/mentees/$mentee
        sudo setfacl -m g::0 /home/core/mentees/$mentee
        sudo setfacl -m o::0 /home/core/mentees/$mentee
        sudo setfacl -m u:core:rwx /home/core/mentees/$mentee
        sudo setfacl -m u:$mentee:-w- /home/core/$3

        sudo setfacl -m u:$mentee:--x /home
    done
    webdev_mentor_list=$(awk 'BEGIN{FS=" ";} $0!~/^Name/{if ($2 ~ /web/) print $1;}' $1)
    for mentor in $webdev_mentor_list
    do
        sudo useradd -m -d /home/core/mentors/Webdev/$mentor -g mentors_grp $mentor
        sudo setfacl -m g:sudo:rwx /home/core/mentors/Webdev/$mentor
        cd /home/core/mentors/Webdev/$mentor
        touch Alottedmentees.txt
        mkdir submitted_tasks
        cd submitted_tasks
        mkdir task1 task2 task3

        sudo setfacl -m g::0 /home/core/mentors/$mentor
        sudo setfacl -m o::0 /home/core/mentors/$mentor
        sudo setfacl -m u:core:rwx /home/core/mentors/Webdev/$mentor
        sudo setfacl -m u:$mentor:r-x /home/core 
        sudo setfacl -m u:$mentor:r-x /home/core/mentees
        sudo setfacl -m u:$mentor:r-x /home/core/mentors
        sudo setfacl -m u:$mentor:r-x /home/core/mentors/Webdev 
        sudo setfacl -m u:$mentor:--x /
        sudo setfacl -m u:$mentor:--x /home

    done
    appdev_mentor_list=$(awk 'BEGIN{FS=" ";} $0!~/^Name/{if ($2 ~ /app/) print $1;}' $1)
    for mentor in $appdev_mentor_list
    do
        sudo useradd -m -d /home/core/mentors/Appdev/$mentor -g mentors_grp $mentor
        sudo setfacl -m g:sudo:rwx /home/core/mentors/Appdev/$mentor
        cd /home/core/mentors/Appdev/$mentor
        touch Alottedmentees.txt
        mkdir submitted_tasks
        cd submitted_tasks
        mkdir task1 task2 task3
        sudo setfacl -m g::0 /home/core/mentors/Appdev/$mentor

        sudo setfacl -m o::0 /home/core/mentors/Appdev/$mentor

        sudo setfacl -m u:core:rwx /home/core/mentors/Appdev/$mentor
        sudo setfacl -m u:$mentor:r-x /home/core 
        sudo setfacl -m u:$mentor:r-x /home/core/mentees
        sudo setfacl -m u:$mentor:r-x /home/core/mentors
        sudo setfacl -m u:$mentor:r-x /home/core/mentors/Appdev 
        sudo setfacl -m u:$mentor:--x /
        sudo setfacl -m u:$mentor:--x /home

    done
    sysad_mentor_list=$(awk 'BEGIN{FS=" ";} $0!~/^Name/{if ($2 ~ /sysad/) print $1;}' $1)
    for mentor in $sysad_mentor_list
    do
        sudo useradd -m -d /home/core/mentors/Sysad/$mentor -g mentors_grp $mentor
        sudo setfacl -m g:sudo:rwx /home/core/mentors/Sysad/$mentor
        cd /home/core/mentors/Sysad/$mentor
        touch Alottedmentees.txt
        mkdir submitted_tasks
        cd submitted_tasks
        mkdir task1 task2 task3
        sudo setfacl -m g::0 /home/core/mentors/Sysad/$mentor
        sudo setfacl -m o::0 /home/core/mentors/Sysad/$mentor
        sudo setfacl -m u:core:rwx /home/core/mentors/Sysad/$mentor
        sudo setfacl -m u:$mentor:r-x /home/core 
        sudo setfacl -m u:$mentor:r-x /home/core/mentees
        sudo setfacl -m u:$mentor:r-x /home/core/mentors
        sudo setfacl -m u:$mentor:r-x /home/core/mentors/Sysad 
        sudo setfacl -m u:$mentor:--x /
        sudo setfacl -m u:$mentor:--x /home

    done

}

usergen_func ()
{
    if [[ -e /home/core ]]
    then
        echo "Users and permissions have already been setup"
        read -p "Do you want to override them? (Y/n)" opinion
        if [[ $opinion = "Y" || $opinion = "y" ]]
        then 
            thepwd=$(pwd)
            setupfunc $1 $2 ${3#~/*} 2> /dev/null
            if [ $? -eq 0 ]
            then 
                echo "Users and permissions have been done successfully"
            else
                echo "There was an unexpected problem :("
                echo "Try again later"
            fi
            cd $thepwd
        fi
        
    else
        thepwd=$(pwd)
        setupfunc $1 $2 ${3#~/*} 2> /dev/null
        if [ $? -eq 0 ]
        then 
            echo "Users and permissions have been done successfully"
        else
            echo "There was an unexpected problem :("
            echo "Try again later"
        fi
        cd $thepwd
    fi
}

alias usergen="usergen_func ~/mentor_details.txt ~/mentee_details.txt ~/mentee_domain.txt"     




