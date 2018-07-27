# change cursor to blinking block
echo -ne "\x1b[1 q"

#PS1='${LOGNAME}@$(/usr/bin/hostname):$(
#    [[ "${LOGNAME}" == "root" ]] && printf "%s" "${PWD/${HOME}/~}# " ||
#    printf "%s" "${PWD/${HOME}/~}\$ ")'

export PS1="[\u@\[$(tput sgr0)\]\[\033[38;5;190m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]] \[$(tput sgr0)\]\[\033[38;5;82m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;9m\]->\[$(tput sgr0)\]"

# Aliases for days
alias ll='ls -lF'
alias ls='ls --color=auto'
alias nano='vim'
alias vi='vim'

# Bash completion
for bcfile in /etc/bash/bash_completion.d/* ; do
  . $bcfile
done

# Function allowing for use of <alias> in place of <uuid> when alias is unique
# Thanks to Jorge Schrauwen, Michael Lustfield, Nick Vandal for contributing the basis of these scripts to the SmartOS wiki
# https://wiki.smartos.org/display/DOC/Refer+to+Virtual+Machines+by+Alias#RefertoVirtualMachinesbyAlias-Wrapperfunction
function vmadm
{
    local input=""
    if [[ ! -t 0 ]]; then
        while read -r words;
        do
            input=$input$words;
        done
    fi
    local op=$1; shift
    if [[ "${op}" == "alias" ]]; then
        case $# in
            0)
                echo "Usage:"
                echo ""
                echo "vmadm alias <alias>"
                echo " -or- vmadm alias <command> <alias> [options]"
                ;;
            1)
                echo ${input} | /usr/sbin/vmadm lookup alias=$1
                ;;
            *)
                op=$1; shift
                local vm_alias=$1; shift
                local uuid=$(vmadm lookup -1 alias=${vm_alias})
                if [[ -n ${uuid} ]]; then
                    echo ${input} | /usr/sbin/vmadm ${op} ${uuid} $@
                fi
                ;;
        esac
    else
        echo ${input} | /usr/sbin/vmadm  ${op} $@
    fi
    return $?
}


function zlogin
{
        case $# in
                0)
                        echo "zlogin wrapper usage:"
                        echo ""
                        echo "zlogin alias <alias> [args]"
                        echo " -or- zlogin <UUID> [args]"
                        ;;
                *)
                        if [[ $1 == "alias" ]] || [[ $1 == "a" ]]; then
                                local vm_alias=$2
                                local uuid=$(vmadm lookup -1 alias=${vm_alias})

                                shift; shift

                                /usr/sbin/zlogin ${uuid} "$@"
                        else
                                /usr/sbin/zlogin "$@"
                        fi
                        ;;
        esac
                                
        return $?
}

# Start in /opt/ by default
cd /opt/
