# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt autocd extendedglob nomatch notify globdots correctall histignorespace
bindkey -e
HISTFILE=~/.zsh_history

export ZSH=/usr/share/oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(copybuffer extract fasd fzf git man safe-paste sudo zsh-autosuggestions zsh-completions zsh-syntax-highlighting history-substring-search)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow,bold,underline"

[[ ! -f $ZSH/oh-my-zsh.sh ]] || source $ZSH/oh-my-zsh.sh
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

if [ -d "$HOME/.local/bin" ] ;
  then export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.npm-global/bin" ] ;
  then export PATH="$HOME/.npm-global/bin:$PATH"
fi

if command -v nvim &> /dev/null; then
  export EDITOR=nvim
fi

alias exa="exa --icons"
alias exat="exa -Tla"
alias exaa="exa -a"
alias exal="exa -la"


alias get="aria2c -x16 -s64 -j64 -k2M"
alias hogs="sudo nethogs"

alias full="swallow"
alias routine="full zathura $HOME/Dropbox/routine.pdf"
alias pdf="full zathura"
alias play="full mpv"

alias update="sudo pacman -Syu"
alias updateaur="yay -Syua --devel --timeupdate"
alias updatelocalpkgs="automakepkg ~/.local/builds"
alias sysup="update;updateaur;updatelocalpkgs"
alias mirror="sudo reflector --verbose --country \"Hong Kong\",Bangladesh,Japan,China --sort age --fastest 6 --score 15 --save /etc/pacman.d/mirrorlist"

exist () {
  nohup $@ > /dev/null &
}

fzf-file-cd () {
    folder=$(find . 2>/dev/null | cut -c3- | fzf --height 40% --reverse)
    if [ -d $folder ]; then
        cd $folder
    else
        cd $(dirname $folder)
    fi
}
alias ff="fzf-file-cd"

sleep 0.05; clear
