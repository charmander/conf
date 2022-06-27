#!/usr/bin/env python3
import os
import shutil
import sys
from pathlib import Path


LINK = [
	# Shell
	("profile", ".profile"),
	("zprofile", ".zprofile"),
	("zshrc", ".zshrc"),

	# Windows
	("sway/config", ".config/sway/config"),

	# Vim
	("vim/after", ".vim/after"),
	("vim/autoload", ".vim/autoload"),
	("vim/bundle", ".vim/bundle"),
	("vim/colors", ".vim/colors"),
	("vim/ftdetect", ".vim/ftdetect"),
	("vim/gvimrc", ".vim/gvimrc"),
	("vim/syntax", ".vim/syntax"),
	("vim/vimrc", ".vim/vimrc"),
	("vim/after", ".config/nvim/after"),
	("vim/autoload", ".config/nvim/autoload"),
	("vim/bundle", ".config/nvim/bundle"),
	("vim/colors", ".config/nvim/colors"),
	("vim/ftdetect", ".config/nvim/ftdetect"),
	("vim/syntax", ".config/nvim/syntax"),
	("vim/vimrc", ".config/nvim/init.vim"),
	("vim/ginit.vim", ".config/nvim/ginit.vim"),

	# Other
	("alacritty/alacritty.yml", ".config/alacritty/alacritty.yml"),
	("gitconfig", ".gitconfig"),
	("psqlrc", ".psqlrc"),
	("rgignore", ".rgignore"),
]

COPY = [
	("npmrc", ".npmrc"),
]


def ensure_link(to, at):
	try:
		os.symlink(to, at)
	except FileExistsError:
		if is_linked(to, at):
			return False

		raise

	return True


def is_linked(to, at):
	if not isinstance(to, Path):
		raise TypeError("expected Path")

	try:
		return Path(os.readlink(at)) == to
	except OSError:
		return False


def ensure_relative_link(to, at):
	return ensure_link(Path(os.path.relpath(to, start=at.parent)), at)


def main():
	abs_root = Path(os.path.realpath(__file__)).parent
	root = abs_root
	home = Path.home()

	success = True

	for to, at in LINK:
		try:
			created = ensure_relative_link(root / to, home / at)
		except FileExistsError:
			print(f"~/{at} already exists", file=sys.stderr)
			success = False
		else:
			if created:
				print(f"Linked ~/{at}", file=sys.stderr)

	for from_, to in COPY:
		with open(abs_root / from_, "r", encoding="utf-8") as from_file:
			try:
				with open(home / to, "x", encoding="utf-8") as to_file:
					shutil.copyfileobj(from_file, to_file)
			except FileExistsError:
				print(f"~/{to} already exists", file=sys.stderr)
				success = False
			else:
				print(f"Wrote ~/{to}", file=sys.stderr)

	try:
		os.makedirs(home / ".tmp/vim-undo")
	except FileExistsError:  # documentation says “an OSError”, but it is a specific one
		pass
	else:
		print("Created empty ~/.tmp/vim-undo", file=sys.stderr)

	if not success:
		raise SystemExit(1)


if __name__ == "__main__":
	main()
