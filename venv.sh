# Skinny virtualenv wrapper
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
    echo "  rm <venvnames>  Removes <venvname> virtualenv"
}

# God object
function venv {
    [ $VENV_HOME ] || local VENV_HOME=$HOME/.virtualenvs
    local VENV_DIR=$VENV_HOME/$(basename $PWD)
    local VENV_PY=python3
    local VENV_FILE=.venv
    local VENV_VER=
    case $1 in
        on)
            [ $VIRTUAL_ENV ] && deactivate
            [ "$2" = '2' ] && VENV_VER='2' && VENV_DIR+='_PY2' && VENV_PY=python2
            [ ! -d $VENV_DIR ] && $(which virtualenv) $VENV_DIR -p $VENV_PY
            [ -f $VENV_FILE$VENV_VER -a "$(cat $VENV_FILE$VENV_VER)" != $VENV_DIR ] && echo $VENV_DIR > $VENV_FILE$VENV_VER
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
        help)
            _venv_help
            ;;
        *)
            if [ ! $VIRTUAL_ENV -a -e .venv -a -e .venv2 ]; then
                echo 'There are virtualenvs for both python 2 and 3.\n'
                echo 'To activate '`basename $(cat .venv2)`' environment, type 2 and press [ENTER].'
                echo 'To activate '`basename $(cat .venv)`', just press [ENTER]:'
                read VENV_VER
                case $VENV_VER in
                    (''|2)
                        venv on $VENV_VER
                        ;;
                    *)
                        echo 'Wrong choice'
                        ;;
                esac
            else
                _venv_help
            fi
            ;;
    esac
}
