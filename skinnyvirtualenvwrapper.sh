# Skinny virtualenv wrapper

# WIP
function tesssst {
    if [ -e .venv -a -e .venv2 ]; then
        echo 'There are virtualenvs for both python 2 and 3.\n'
        echo 'To activate '`basename $(cat .venv2)`' environment, type 2 and press [ENTER].'
        echo 'To activate '`basename $(cat .venv)`', just press [ENTER]:'
        read version
        case $version in
            (''|2)
                cat .venv$version
                ;;
            *)
                echo 'Wrong choice'
                ;;
        esac
    fi
}

function _venv_help {
    echo "Skinny virtualenv wrapper"
    echo "Usage: venv [cmd] <args>\n"
    echo "Commands:"
    echo "  on <2>          Creates virtualenv under $HOME/.virtualenvs/"
    echo "                  if it doesn't exist and activates it"
    echo "                  python3 is default. Run '$ venv on 2'"
    echo "                  to create python2 environment"
    echo "  off             Deactivates virtualenv"
    echo "  ls              Lists all virtualenvs"
    echo "  rm <venvnames>   Removes <venvname> virtualenv"
}

# God object
function venv {
    local VENV_HOME=$HOME/.virtualenvs
    local VENV_DIR=$HOME/.virtualenvs/$(basename $PWD)
    local VENV_FILE=.venv
    local VENV_VER=''
    case $1 in
        on)
            [ "$2" = '2' ] && VENV_VER='2' && VENV_DIR+='_PY2'
            [ $VIRTUAL_ENV ] && deactivate
            [ ! -d $VENV_DIR ] && $(which virtualenv) $venvdir -p 'python'$VENV_VER
            echo $VENV_DIR > $VENV_FILE$VENV_VER
            source $VENV_DIR/bin/activate
            ;;
        off)
            [ $VIRTUAL_ENV ] && deactivate
            ;;
        ls)
            for d in $(ls -d $VENV_HOME/*); do echo $fg[magenta]${d##*/}$reset_color; done
            ;;
        rm)
            shift
            if [ $# -gt 0 ]; then
                for d in $*; do
                    rm -r $VENV_HOME/$d && echo 'Virtualenv '$d' removed'
                done
            else
                echo 'You must provide at least one virtualenv name to remove it'
            fi
            ;;
        *)
            _venv_help
            ;;
    esac
}
