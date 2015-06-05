# include all subscripts
[ -r .path ]       && source .path
[ -r .colors ]     && source .colors
[ -r .exports ]    && source .exports
[ -r .aliases ]    && source .aliases
[ -r .shopt ]      && source .shopt
[ -r .completion ] && source .completion
[ -r .prompt ]     && source .prompt
