setopt autocd correct extendedglob globdots histignorespace nocorrectall nomatch notify
bindkey -e
HISTFILE=~/.zsh_history

export ZSH=/usr/share/oh-my-zsh
plugins=(bgnotify colored-man-pages command-not-found copybuffer copyfile copypath cp extract fasd fzf git man safe-paste sudo zsh-autosuggestions zsh-completions zsh-hist zsh-interactive-cd zsh-syntax-highlighting history-substring-search)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow,bold,underline"

[[ ! -f $ZSH/oh-my-zsh.sh ]] || source $ZSH/oh-my-zsh.sh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

if [ -d "$HOME/.local/bin" ] ;
  then export PATH="$HOME/.local/bin:$PATH"
fi

if command -v nvim &> /dev/null; then
  export EDITOR=nvim
fi

alias exa="exa --icons"
alias exat="exa -Tla"
alias exaa="exa -a"
alias exal="exa -la"

alias get="aria2c --continue=true --max-connection-per-server=16 --split=64 --max-concurrent-downloads=64 --min-split-size=2M"
alias hogs="sudo nethogs -C"

alias full="swallow"
alias routine="full zathura $HOME/Dropbox/routine.pdf"
alias pdf="full zathura"
alias play="full mpv"

alias update="sudo pacman -Syu"
alias updateaur="yay -Syua --devel --timeupdate"
alias updatelocalpkgs="automakepkg ~/.local/builds"
alias sysup="update;updateaur;updatelocalpkgs"
alias mirror="sudo reflector --verbose --country \"Hong Kong\",Bangladesh,Japan,China --sort age --fastest 6 --score 15 --save /etc/pacman.d/mirrorlist"

alias clockin="source ~/.workrc"

e () {
  (
    unsetopt multios
    $@ &>! /dev/null &!
  )
}

rscp () {
  cpv --no-progress --info=progress2 "$@"
}

rsmv () {
  rscp --remove-source-files "$@"
}

fzf-file-cd () {
    folder=$(find . 2>/dev/null | cut -c3- | fzf --height 40% --reverse)
    if [ -d $folder ]; then
        cd $folder
    else
        cd $(dirname $folder)
    fi
}
alias zz="fzf-file-cd"

alias convertpdf="libreoffice --headless --invisible --convert-to pdf"

eval "$(starship init zsh)"
