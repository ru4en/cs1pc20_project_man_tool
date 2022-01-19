#!/bin/bash
function pm_tree {
    fileloc="${1%%.*}"
    tree_code=$(tree $fileloc --dirsfirst --noreport | iconv -f utf-8 -t us-ascii//TRANSLIT | sed -e '1d' -e 's/|/+/' -e 's/|/+/' -e 's/--/_/' -e 's/ //g' -e 's/_/ /g' -e 's/^/+/' )
    echo "
    @startwbs
    + $(basename $fileloc)
    $tree_code
    @endwbs
    " > $fileloc/docs/treeuml.txt
    treeuml_loc=$fileloc"docs/"
    echo $treeuml_loc
    plantuml $fileloc/docs/treeuml.txt --overwrite -o $treeuml_loc
    jq -r '.tree="'$treeuml_loc'treeuml.png"' $1 
    echo "Created tree diagram at "$treeuml_loc
}

if [[ $1 == "tree" ]]; then pm_tree $2
elif [[ $1 == "addusr" ]]; then pm_addusr $2
fi