#!/bin/bash

#Colours
red="\033[00;31m"
RED="\033[01;31m"

green="\033[00;32m"
GREEN="\033[01;32m"

brown="\033[00;33m"
YELLOW="\033[01;33m"

blue="\033[00;34m"
BLUE="\033[01;34m"

purple="\033[00;35m"
PURPLE="\033[01;35m"

cyan="\033[00;36m"
CYAN="\033[01;36m"

white="\033[00;37m"
WHITE="\033[01;37m"

NC="\033[00m"

PARAMS=""
while (( "$#" )); do
    case "$1" in
        -d|--dir-terraform)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
            DIR_WORKSPACE=$2
            shift 2
            else
            echo "Error: Argument for $1 is missing" >&2
            exit 1
            fi
            ;;
        -n|--module-name)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
            MODULE_NAME=$2
            shift 2
            else
            echo "Error: Argument for $1 is missing" >&2
            exit 1
            fi
            ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done

banner () {
echo -e ""
echo -e "${GREEN}******************************************************************************"
echo -e "${WHITE} Module:    ${YELLOW}$MODULE_NAME"
echo -e "${WHITE} Workspace: ${YELLOW}$WORKSPACE"
echo -e "${WHITE} Date:      ${YELLOW}"`date`
echo -e ""
}

if [ ! -f $DIR_WORKSPACE/workspace ]; then
    WORKSPACE="default"
    echo $WORKSPACE > $DIR_WORKSPACE/workspace
fi

if [ $(jq '.[0]' <<< "$TF_VAR_COMMAND" | tr -d \") == "workspace" ]; then
    if [ $(jq '.[1]' <<< "$TF_VAR_COMMAND" | tr -d \") == "list" ]; then
        WORKSPACE=$(terraform workspace show)
        banner
        echo -e "${CYAN} Workspace list:"
        echo -e "${WHITE}"
        echo $WORKSPACE > $DIR_WORKSPACE/workspace
    elif [ $(jq '.[1]' <<< "$TF_VAR_COMMAND" | tr -d \") == "select" ]; then
        WORKSPACE=$(terraform workspace show)
        banner
        WORKSPACE=$(jq '.[2]' <<< "$TF_VAR_COMMAND" | tr -d \")
        echo -e "${WHITE} Change workspace ${YELLOW}$(terraform workspace show) ${WHITE}to ${GREEN}$WORKSPACE"
        echo -e ""
        echo $WORKSPACE > $DIR_WORKSPACE/workspace
    elif [ $(jq '.[1]' <<< "$TF_VAR_COMMAND" | tr -d \") == "new" ]; then
        WORKSPACE=$(terraform workspace show)
        banner
        WORKSPACE=$(jq '.[2]' <<< "$TF_VAR_COMMAND" | tr -d \")
        echo -e "${WHITE} Creating workspace ${GREEN}$WORKSPACE..."
        echo -e ""
        echo $WORKSPACE > $DIR_WORKSPACE/workspace
    elif [ $(jq '.[1]' <<< "$TF_VAR_COMMAND" | tr -d \") == "delete" ]; then
        WORKSPACE=$(terraform workspace show)
        banner
        WORKSPACE=$(jq '.[2]' <<< "$TF_VAR_COMMAND" | tr -d \")
        echo -e "${WHITE} Removing workspace ${GREEN}$WORKSPACE..."
        echo -e ""
    fi
else
    WORKSPACE=$(cat $DIR_WORKSPACE/workspace)
    banner
    terraform workspace select $WORKSPACE
fi