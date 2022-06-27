#!/bin/sh

set -eu

test "$1" = --embed
test "$2" = --cmd

case "$3" in
*rtp*) ;;
*) false ;;
esac

test "$4" = --cmd
test "$5" = 'set termguicolors'

shift 5

exec nvim --embed --cmd 'set runtimepath+=/usr/share/nvim-qt/runtime' --cmd 'set termguicolors' "$@"
