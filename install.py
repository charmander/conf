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
	("spectrwm.conf", ".spectrwm.conf"),
	("xinitrc", ".xinitrc"),
	("Xresources", ".Xresources"),

	# Other
	("gitconfig", ".gitconfig"),
	("rgignore", ".rgignore"),
]

COPY = [
	("npmrc", ".npmrc"),
]

VIM_LINK = [
	"autoload",
	"bundle",
	"colors",
	"gvimrc",
	"syntax",
	"vimrc",
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


def main(relative=True):
	abs_root = Path(os.path.realpath(__file__)).parent
	root = abs_root
	vim_src = root / "vim"
	home = Path.home()

	if relative:
		root = root.relative_to(home)
		vim_src = ".." / root / "vim"

	success = True

	for from_, to in LINK:
		try:
			created = ensure_link(root / from_, home / to)
		except FileExistsError:
			print(f"~/{to} already exists", file=sys.stderr)
			success = False
		else:
			if created:
				print(f"Linked ~/{to}", file=sys.stderr)

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

	vim_dest = home / ".vim"

	try:
		os.mkdir(vim_dest)
	except FileExistsError:
		if not all(is_linked(vim_src / name, vim_dest / name) for name in VIM_LINK):
			print("~/.vim already exists", file=sys.stderr)
			success = False
	else:
		for name in VIM_LINK:
			os.symlink(vim_src / name, vim_dest / name)
			print(f"Linked ~/.vim/{name}", file=sys.stderr)

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
