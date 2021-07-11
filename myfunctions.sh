#!/bin/bash
# Default opts that set the dracula fzf color theme
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 --height 80% --layout=reverse --border'

# Default command
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/" --glob "!node_modules/" --glob "!vendor/"'

# Preview them using bat
export BAT_THEME='gruvbox-dark'

function displayFZFFiles {
    echo $(fzf --preview 'bat --theme=TwoDark --color=always --style=header,grid --line-range :400 {}')
}

function nvimGoToFiles {
    selection=$(displayFZFFiles)
    if [ -z "$selection" ]; then
        return;
    else
        nvim $selection
    fi;
}

function vimGoToFiles {
    selection=$(displayFZFFiles)
    if [ -z "$selection" ]; then
        return;
    else
        vim $selection
    fi;
}

function displayRgPipedFzf {
    echo $(rg . -n --glob "!.git/" --glob "!vendor/" --glob "!node_modules/" | fzf)
}

function nvimGoToLine {
    selection=$(displayRgPipedFzf)
    if [ -z "$selection" ]; then
      return;
    else 
        #nvim $(nvgotoline $selection) +"normal zz"
        filename=$(echo $selection | awk -F ':' '{print $1}')
        line=$(echo $selection | awk -F ':' '{print $2}')
        nvim $(printf "+%s %s" $line $filename) +"normal zz"
    fi
}

function vimGoToLine {
    selection=$(displayRgPipedFzf)
    if [ -z "$selection" ]; then
      return;
    else 
        #vim $(nvgotoline $selection) +"normal zz"
        filename=$(echo $selection | awk -F ':' '{print $1}')
        line=$(echo $selection | awk -F ':' '{print $2}')
        if [ "$TERM" != "xterm-256color" ]; then
            TERM="xterm-256color"
        fi
        vim $(printf "+%s %s" $line $filename) +"normal zz"
    fi
}

alias vf='vimGoToFiles'
alias nf='nvimGoToFiles'
alias nvl='nvimGoToLine'
alias vl='vimGoToLine'
