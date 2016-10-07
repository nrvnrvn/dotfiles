# Skinny virtualenv wrapper
function _venv_help {
    echo "Skinny virtualenv wrapper"
    echo "Usage: venv <command> [args]\n"
    echo "Commands:"
    echo "  on [version]        Creates virtualenv under $HOME/.virtualenvs/"
    echo "                      if it doesn't exist and activates it."
    echo "                      python3.5 is default. Available options:"
    echo "                      2.6, 2.7(2), 3.3, 3.4, 3.5(3)"
    echo "  off                 Deactivates current virtualenv"
    echo "  ls                  Lists all virtualenvs"
    echo "  rm <venv>...        Removes listed venv/venvs"
}

# God object
function venv {
    if [ ! $(command -v virtualenv) ]; then
        echo "command not found: virtualenv"
        return 1
    fi
    [ $VENV_HOME ] || local VENV_HOME=$HOME/.virtualenvs
    [ $VENV_SFX ] || local VENV_SFX='_PY35'
    [ $VENV_PY ] || local VENV_PY=python3.5
    local VENV_DIR=$VENV_HOME/${PWD##*/}
    local VENV_FILE=.env
    case $1 in
        on)
            local VENV_SEARCH_ROOT=$PWD
            while [ $VENV_SEARCH_ROOT ]; do
                if [ -f $VENV_SEARCH_ROOT/$VENV_FILE ]; then
                    VENV_DIR=$VENV_HOME/${VENV_SEARCH_ROOT##*/}
                    VENV_FILE=$VENV_SEARCH_ROOT/$VENV_FILE
                    # if [[ "$(cat $VENV_SEARCH_ROOT/$VENV_FILE)" = $VENV_HOME* ]]; then
                    #     if [[ "$(cat $VENV_SEARCH_ROOT/$VENV_FILE)" = *$VENV_SFX ]]; then
                    #         VENV_DIR=$(cat $VENV_SEARCH_ROOT/$VENV_FILE)
                    #         break
                    #     fi
                    # fi
                    break
                fi
                VENV_SEARCH_ROOT=${VENV_SEARCH_ROOT%/*}
            done
            case $2 in
                2.6)
                    VENV_DIR+='_PY26'
                    VENV_PY=python2.6
                    ;;
                2|2.7)
                    VENV_DIR+='_PY27'
                    VENV_PY=python2.7
                    ;;
                3.3)
                    VENV_DIR+='_PY33'
                    VENV_PY=python3.3
                    ;;
                3.4)
                    VENV_DIR+='_PY34'
                    VENV_PY=python3.4
                    ;;
                3|3.5)
                    VENV_DIR+='_PY34'
                    VENV_PY=python3.5
                    ;;
                '')
                    VENV_DIR+=$VENV_SFX
                    ;;
                *)
                    _venv_help
                    return 1
                    ;;
            esac
            if [ ! $(command -v $VENV_PY) ]; then
                echo "$VENV_PY not found"
                return 1
            fi
            [ $VIRTUAL_ENV ] && deactivate
            [ -f $VENV_DIR/bin/activate ] || $(command -v virtualenv) $VENV_DIR -p $VENV_PY
            [ -f $VENV_FILE ] && [ "$(cat $VENV_FILE)" = $VENV_DIR ] || echo $VENV_DIR > $VENV_FILE
            source $VENV_DIR/bin/activate
            ;;
        off)
            [ $VIRTUAL_ENV ] && deactivate
            ;;
        ls)
            for d in $(ls -d $VENV_HOME/*); do echo ${d##*/}; done
            ;;
        rm)
            shift
            if [ $# -eq 0 ]; then
                echo 'You must provide at least one virtualenv name to remove it'
                return 1
            fi
            for d in $*; do
                if [ ! -d $VENV_HOME/$d ]; then
                    echo "No such venv $d"
                    return 1
                fi
                if [ "$VENV_HOME/$d" = "$VIRTUAL_ENV" ]; then
                    echo "Virtualenv $d is currently active."
                    echo "Do you really want ot remove it? [yes/no]:"
                    read VENV_RM
                    case $VENV_RM in
                        y|yes)
                            venv off
                            ;;
                        n|no)
                            continue
                            ;;
                        *)
                            echo "Wrong choice"
                            continue
                            ;;
                    esac
                fi
                rm -rf $VENV_HOME/$d &>/dev/null && echo "Virtualenv $d removed"
            done
            ;;
        *)
            _venv_help
            ;;
    esac
}
