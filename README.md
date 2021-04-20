# dotfiles

My personal dotfiles, published here mainly for my own convenience.

`init.sh` will create the required symbolic links, overwriting existing links but preserving any existing regular files.
Regular files can also be overwritten by providing the '-f' flag.

Of particular note is the `sd` script included in `.local/bin`, whose concept is courtesy of [Ian Henry][1]. The
corresponding scripts are provided in `.sd`. Please note that these scripts are highly specific to my personal
machine(s) and workflow, so most will probably be of little utility to others.

[1]: https://ianthehenry.com/posts/sd-my-script-directory/
