# Add user configurations here
# For HyDE to not touch your beloved configurations,
# we added a config file for you to customize HyDE before loading zshrc
# Edit $ZDOTDIR/.user.zsh to customize HyDE before loading zshrc

#  Plugins 
# oh-my-zsh plugins are loaded  in $ZDOTDIR/.user.zsh file, see the file for more information

#  Aliases 
# Override aliases here in '$ZDOTDIR/.zshrc' (already set in .zshenv)

# # Helpful aliases
alias c='clear'                                                        # clear terminal
alias cls='clear'
alias l='eza -lh --icons=auto'                                         # long list
alias ls='eza -1 --icons=auto'                                         # short list
alias lsa='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto'                                       # long list dirs
alias lt='eza --icons=auto --tree'                                     # list folder as tree
alias un='$aurhelper -Rns'                                             # uninstall package
alias up='$aurhelper -Syu'                                             # update system/package/aur
# alias pl='$aurhelper -Qs'                                              # list installed package
# alias pa='$aurhelper -Ss'                                              # list available package
# alias pc='$aurhelper -Sc'                                              # remove unused cache
alias cleanup='$aurhelper -Qtdq | $aurhelper -Rns -'                        # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias vc='vscodium'                                                        # gui code editor
alias fastfetch='fastfetch --logo-type kitty'
alias nv='nvim .'

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Git aliases 
alias gaa='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'

# # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

#  This is your file 
# Add your configurations here
export EDITOR=nvim
export TERMINAL=kitty

unset -f command_not_found_handler # Uncomment to prevent searching for commands not found in package manager

# pnpm lazy loading with hash -d
function pnpm() {
	unfunction pnpm
  export PNPM_HOME="/home/gustavo/.local/share/pnpm"

  if ! echo "$PATH" | grep -q "$PNPM_HOME"; then
    export PATH="$PNPM_HOME:$PATH"
  fi

  pnpm "$@"
}

# Load nvm scripts only if they haven't been loaded yet
function load_nvm {
	export NVM_DIR="$HOME/.config/nvm"
	if [ ! -f "$NVM_DIR/nvm.sh" ]; then
		echo "NVM scripts not found at $NVM_DIR. Please check your NVM_DIR." >&2
		return 1
	fi

	# Load nvm and its bash completion
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

}

function nvm {
  unfunction nvm
  load_nvm
	nvm "$@"
}

# Loads npm
function npm {
  unfunction npm
  load_nvm
  npm "$@"
}

# pnpm
export PNPM_HOME="/home/gustavo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
