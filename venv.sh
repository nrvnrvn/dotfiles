# Skinny virtualenv wrapper
function _venv_help {
    echo "Skinny virtualenv wrapper"
    echo "Usage: venv [command] [args]\n"
    echo "Commands:"
    echo "  on [2]                  Creates virtualenv under $HOME/.virtualenvs/"
    echo "                          if it doesn't exist and activates it"
    echo "                          python3.4 is default. Available options:"
    echo "                          2.6, 2.7(2), 3.3, 3.4(3)"
    echo "                          to create python2 environment"
    echo "  off                     Deactivates current virtualenv"
    echo "  ls                      Lists all virtualenvs"
    echo "  rm venv [venv] [...]    Removes listed venv/venvs"
}

# God object
function venv {
    [ $VENV_HOME ] || local VENV_HOME=$HOME/.virtualenvs
    local VENV_DIR=$VENV_HOME/${PWD##*/}
    local VENV_PY
    local VENV_FILE=.venv
    case $1 in
        on)
            case $2 in
                (2|2.7)
                    VENV_DIR+='_PY27'
                    VENV_PY=python2.7
                    ;;
                2.6)
                    VENV_DIR+='_PY26'
                    VENV_PY=python2.6
                    ;;
                3.3)
                    VENV_DIR+='_PY33'
                    VENV_PY=python3.3
                    ;;
                ''|3|3.4)
                    VENV_DIR+='_PY34'
                    VENV_PY=python3.4
                    ;;
                *)
                    return 1
                    ;;
            esac
            [ $VIRTUAL_ENV ] && deactivate
            [ "$2" = '2' ] && VENV_VER='2' && VENV_DIR+='_PY2' && VENV_PY=python2
            [ -f $VENV_DIR/bin/activate ] || $(which virtualenv) $VENV_DIR -p $VENV_PY
            [ -f $VENV_FILE ] && [ "$(cat $VENV_FILE)" != $VENV_DIR ] && echo $VENV_DIR > $VENV_FILE
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
