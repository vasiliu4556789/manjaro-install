#!/bin/zsh

export TERM="xterm-256color" # This sets up colors properly
export EDITOR='micro'
export PATH="$PATH:~/.dotnet/tools"
export GTK_USE_PORTAL=1



#autoload -U compinit && compinit

# просто наберите нужный каталог и окажитесь в нём
setopt autocd

# Language
#export LANGUAGE=en_US.UTF-8
#export LC_LANG=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
# You may need to manually set your language environment
#export LANG=en_US.UTF-8
#export LANG=ru_RU.UTF-8
#export LANG=en_US.UTF-8

# set shell
export SHELL=/usr/bin/zsh

#tilix
if [[ $TILIX_ID ]]; then
        source /etc/profile.d/vte.sh
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZLE_RPROMPT_INDENT=0
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk


# programs      
zinit silent wait light-mode from:gh-r as:program for \
      mv:'bat-**/bat -> bat' @sharkdp/bat \
      mv:'exa-* -> exa' @ogham/exa \
      @junegunn/fzf-bin
      
export BAT_THEME="base16-256" 

zinit light garabik/grc


# fzf-z ctrl+g последние каталоги
# ctrl+t переход по каталогам в текущем 
zinit silent wait light-mode for \
      multisrc:'shell/*.zsh' @junegunn/fzf \
      @ael-code/zsh-colored-man-pages \
      @andrewferrier/fzf-z \
      @changyuheng/fz \
      @Aloxaf/fzf-tab \
      @rupa/z 

#multisrc:'shell/*.zsh' @junegunn/fzf \

      
#zinit light zinit-zsh/z-a-test
#zinit light marlonrichert/zsh-autocomplete
#zinit light ajeetdsouza/zoxide
#eval "$(zoxide init zsh)"

# Fast-syntax-highlighting & autosuggestions
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions
    
#bindkey '\e[A' history-substring-search-up
#bindkey '\e[B' history-substring-search-down    

#powerlevel10k
zinit ice lucid wait='0' atload='_zsh_autosuggest_start' 
zinit ice depth=1; zinit light romkatv/powerlevel10k  


setopt promptsubst
#OMZP  src перегрузить zshrc
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::zsh_reload
zinit snippet OMZP::extract
#zinit snippet OMZP::git
#zinit snippet OMZP::z





## Конфигурация истории
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.



# SSH
#CVS_RSH='ssh'
#RSYNC_RSH='ssh'

## Completion
autoload -U compinit
compinit


#История команд ctrl+z
function h() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | gsed -r 's/ *[0-9]*\*? *//' | gsed -r 's/\\/\\\\/g')
}

zle -N h
bindkey '^z' h



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#alias
[[ ! -f ~/.alias_zsh ]] || source ~/.alias_zsh




#[ -f ~/.resh/shellrc ] && source ~/.resh/shellrc # this line was added by RESH (Rich Enchanced Shell History)
