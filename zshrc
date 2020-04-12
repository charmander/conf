autoload -Uz edit-command-line
zle -N edit-command-line

# Key bindings
bindkey -e
bindkey ^F history-incremental-search-forward
bindkey -r ^S
bindkey ^X^E edit-command-line

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
alias scp='echo don’t use scp'

np() {
	local p
	p=$(nosepass "$@") || return 1
	echo 'Password copied!'
	printf '%s' "$p" | wl-copy -f
}

docker-eslint() {
	docker image inspect eslint > /dev/null && docker run \
		--mount "type=bind,readonly,\"source=${PWD//\"/\"\"}\",destination=/var/build" \
		--network=none --security-opt=no-new-privileges \
		--rm -it eslint "$@"
}

npm() {
	local p="$PWD"

	while [[ -n "$p" && "$p" != "$HOME" ]]; do
		if [[ -e "$p/.npmrc" ]]; then
			printf 'Refusing to run npm with possible local .npmrc at %s/.npmrc\n' "$p" >&2
			return 1
		fi

		p="${p%/*}"
	done

	if [[ "$#" = 1 && pack = "$1" ]]; then
		npm-pack-check
	else
		command npm "$@"
	fi
}

tar() {
	if [[ "$1" = -* ]]; then
		command tar --numeric-owner "$@"
	elif [[ "$1" = *[cru]* ]]; then
		echo 'Refusing to write tar data without --numeric-owner' >&2
		return 1
	else
		command tar "$@"
	fi
}

rl-link() {
	if [[ "$#" -ne 1 ]]; then
		echo 'Usage: rl-link <template>' >&2
		return 1
	fi

	echo ": $1 |> node_modules/.bin/razorleaf %f > %o |> ${1%%.rl}.html" >>! Tupfile
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
