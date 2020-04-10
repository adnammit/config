#!/bin/bash
# only look through files relevant to project launching

a=$PWD

# a stab at omitting search results in inactive client packages
OBSOLETE="
barrett
cadence
fintrack
forrestgeneral
lifebridge
mercy
oums
parkland
rcmc
sfgh
sickkids
skf
ski2
sni
solutions
teletracking
thr
transformation
vaco
visn9
visn10
"

FILES="
*_actions
*_customize_launch
Add_project_team_member
Audit_rollup_page_spec
Classify_project_step
Complete_new_project
Complete_project_func
Complete_request_launch
Custom_form
Custom_form_step
Customize_project_launch
Customize_project_launch_specs
Customize_request_project
Customize_request_project_step
Customize_template
Customize_template_step
Do_complete_new_project
Generate_project_steps
Generate_temporary_form_specs
Init_repository
Launch_*_request
Legacy_request_proj_launch
Make_step
Merge_repositories
Name_project
Name_project_step
New_proj_steps
New_proj_script
New_proj_wizard
New_project_launch_func
New_project_step
On_proj_launch_func
Open_project
Populate_new_project_data
Populate_new_project_roster
Proj_launch_team_member_func
Project_launch_util
Project_list_buttons
Project_report
Quick_setup
Quick_setup_step
Request_customize_setup_steps
Request_launch_script
Request_launch_specs
Request_types
Roster_selection_table
Save_temporary_form_data
Select_audit_step
Select_audit
Select_content_support_step
Select_schedule
Select_schedule_step
Select_template
Select_template_step
Setup_roster_buttons
Setup_step_dialog
Setup_view
Start_up_template
Step_2
Step_3
"

OBS_PATH=""
for OBS in $OBSOLETE ; do
    OBS_PATH=$OBS_PATH"-not -path \"./client/$OBS/*\" "
done

cd ~/dev/dat/
for FILE in $FILES ; do
    # find . -name $FILE.dat* $OBS_PATH | xargs grep $@ --color #why u no work??

    echo ">> $FILE"

    find . -name $FILE.dat* -not -path "./client/barrett/*" -not -path "./client/cadence/*" -not -path "./client/fintrack/*" -not -path "./client/forrestgeneral/*" -not -path "./client/lifebridge/*" -not -path "./client/mercy/*" -not -path "./client/oums/*" -not -path "./client/parkland/*" -not -path "./client/rcmc/*" -not -path "./client/sfgh/*" -not -path "./client/sickkids/*" -not -path "./client/skf/*" -not -path "./client/ski2/*" -not -path "./client/sni/*" -not -path "./client/solutions/*" -not -path "./client/teletracking/*" -not -path "./client/thr/*" -not -path "./client/transformation/*" -not -path "./client/vaco/*" -not -path "./client/visn9/*" -not -path "./client/visn10/*" | xargs grep "${@}" --color

done
cd $a
