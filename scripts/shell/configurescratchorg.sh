#!/bin/sh
# check some laundry list before creating the scratch org
echo "----------------------------------------------------"
echo "------------------------------- Let's check some laundry list before creating the scratch orgs --------------------------------"
# check if user is authorized to devhub and set as default
echo "------------------------------- Have You Authorized to your Dev Hub? Please check If your DevHub is listed and selected as Default ---------------"
echo "------------------------------- Running sfdx force:org:list command to show the current authorized orgs ----DevHub---------------"
sfdx force:org:list
echo "------------------------- Anyways, What is your default DevHub Alias(Choose from above if exists). Please Enter -----------"
read devalias
echo "------------------------- I am going to authorize to your devhub one more time and set as default ----------"
echo "------------------------- Please authorize and come back to the VSCode Terminal -----------"
# Authorize to DevHub and set as default
sfdx force:auth:web:login -d -a $devalias
echo "------------------------------------------------------"
echo "-------------------------- Great Job! ----------------------------"
echo "Do you have sfdx-project json set with default project (y/n)?"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "---------------------------- Great Job!! ----------------------------"
    echo "Do you have forceignore updated with all folders to be ignored (y/n)?"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        echo "------------------------------------ Great ------------------------ "
        #Step 1: Start creating the scratch org
        echo "------------------------------------"
        echo "Let's Create a Scratch Org!"
        #get the alias name for the org
        echo "------------------------------------"
        echo "What alias would you like to give for this org?"
        read orgname
        #get the user name
        echo "------------------------------------"
        echo "What user name would you like to have?"
        read username
        #create scratch org
        echo "------------------------------------"
        echo Creating org $orgname
        sfdx force:org:create -s -f config/project-scratch-def.json -a $orgname username=$username --setdefaultusername --durationdays 30
        #view org configuration data
        echo "------------------------------------"
        echo Org Configuration:
        sfdx force:org:display -u $orgname
        #create a password for the org
        echo "------------------------------------"
        echo Creating default password
        echo "--------- Please make a note(if needed) --------------"
        sfdx force:user:password:generate -u $orgname
        #open the org
        echo "------------------------------------"
        echo Opening org $orgname
        sfdx force:org:open
        #push the source metadatato the org
        echo "------------------------------------"
        echo "Do you have metadata to push (y/n)?"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo "------------------------------------"
            echo "Pushing source to org"
            sfdx force:source:push -f
        else
            echo "------------------------------------"
            echo "No data or metadata to push"
        fi
        #assign profile/ permission set
        echo "------------------------------------"
        echo "Do you wish to assign a default permission set (y/n)?"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            printf "Enter one of the following numbers\n1 Contact Center Admin\n2 for Inside Sales Admin\n"
            read number
            if [[ "$number" -eq 1 ]] ;then
                echo "------------------------------------"
                echo "Assigning default permission set"
                #sfdx force:user:permset:assign -n ContactCenterAdmin
            elif [[ "$number" -eq 2 ]] ;then
                echo "------------------------------------"
                echo "Assigning default permission set"
                #sfdx force:user:permset:assign -n ContactCenterAdmin
            else   
                echo "------------------------------------"
                echo "No permission set assigned"
            fi
        else
            echo "------------------------------------"
            echo "No permission set assigned"
        fi
        #push the source data to the org
        echo "------------------------------------"
        echo "Do you have data to push (y/n)?"

        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo "------------------------------------"
            echo "Pushing data to org"
            sfdx force:data:tree:import -p sfdx-out/AGILE-dev-plan.json
            #run anonymous apex to schedule batch job
            echo "------------------------------------"
            echo "Executing Anonymous Apex"
            sfdx force:apex:execute -f sfdx-out/anon.apex
        else
            echo "------------------------------------"
            echo "No data or metadata to push"
        fi
        echo "------------------------------------"
        echo "That's all Happy Coding!"
        echo "------------------------------------"
        echo "------------------------------------"
    else
        echo "---------------- Please update the forceignore and execute the script again!!-----------------------"
    fi
else
    echo "----------------- Please update the project.Json default folder and execute the script again!!-----------------------"
fi