autoload -Uz edit-command-line
zle -N edit-command-line

# Key bindings
bindkey -e
bindkey ^F history-incremental-pattern-search-forward
bindkey ^R history-incremental-pattern-search-backward
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
alias ls='ls -A -p --color=auto'
alias rg='rg --hidden --smart-case'
alias scp='echo don’t use scp'
alias dup='(alacritty msg create-window --working-directory "$PWD" || alacritty &)'

np() {
	local p
	p=$(nosepass "$@") || return 1
	echo 'Password copied!'
	printf '%s' "$p" | ws-copy -b
}

bwrap-eslint() {
	local dir
	dir="${PWD##*/}"

	env -i bwrap \
		--unshare-all \
		--unshare-user \
		--unshare-cgroup \
		--new-session \
		--die-with-parent \
		--hostname sandbox \
		--ro-bind /bin /bin \
		--ro-bind /lib /lib \
		--ro-bind /lib64 /lib64 \
		--ro-bind /usr/bin /usr/bin \
		--ro-bind /usr/lib /usr/lib \
		--ro-bind . /mnt/"$dir" \
		--remount-ro / \
		--chdir /mnt/"$dir" \
		--setenv HOME /home/sandbox \
		--setenv TERM xterm-256color \
		node_modules/.bin/eslint "$@"
}

bwrap-c8() {
	local dir
	dir="${PWD##*/}"

	mkdir -p coverage
	env -i bwrap \
		--unshare-all \
		--unshare-user \
		--unshare-cgroup \
		--new-session \
		--die-with-parent \
		--hostname sandbox \
		--ro-bind /bin /bin \
		--ro-bind /lib /lib \
		--ro-bind /lib64 /lib64 \
		--ro-bind /usr/bin /usr/bin \
		--ro-bind /usr/lib /usr/lib \
		--ro-bind . /mnt/"$dir" \
		--bind coverage /mnt/"$dir"/coverage \
		--remount-ro / \
		--chdir /mnt/"$dir" \
		--setenv HOME /home/sandbox \
		--setenv TERM xterm-256color \
		node_modules/.bin/c8 "$@"
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
