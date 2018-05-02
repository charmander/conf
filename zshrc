# Key bindings
bindkey -e
bindkey ^F history-incremental-search-forward
bindkey -r ^S

# History
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt autocd
setopt extendedhistory
setopt histfcntllock
setopt histfindnodups
setopt histignorealldups
setopt histignorespace
setopt histsavenodups
setopt histverify
setopt incappendhistory

# Prompt
PROMPT='%~: '

# Functions and aliases
alias ls='ls-personalized -A -p --color=auto'
alias rg='rg --hidden --smart-case'

np() {
	local p
	p=$(nosepass "$@") || return 1
	echo 'Password copied!'
	printf '%s' "$p" | xsel -nbi
}

docker-eslint() {
	docker run \
		--mount "type=bind,readonly,\"source=${PWD//\"/\"\"}\",destination=/var/build" \
		--network=none --security-opt=no-new-privileges \
		--rm -it eslint "$@"
}

# Miscellaneous
unsetopt clobber
setopt interactivecomments
unsetopt flowcontrol
REPORTTIME=10
WORDCHARS="${WORDCHARS//\/}"

# Autocompletion
autoload -Uz compinit
zstyle ':completion:*' verbose yes

compinit
_comp_options+=(globdots)

# Local configuration
source ~/.zshrc.local
