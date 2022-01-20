#!/bin/bash
function pm_tree {
    fileloc="${1%%.*}"
    tmp=$(mktemp)

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
    echo "Created tree diagram at "$treeuml_loc
}

function pm_web {

    fileloc="${1%%.*}"
    treeuml=$fileloc/docs/treeuml.png
    tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
    echo $tmp_dir
    cp $treeuml $tmp_dir/treeuml.png
    ls $tmp_dir
    python3 /lib/pm/webapp.py $1 $tmp_dir
    
    rm -rf $tmp_dir
}

if [[ $1 == "tree" ]]; then pm_tree $2
elif [[ $1 == "addusr" ]]; then pm_addusr $2
elif [[ $1 == "web" ]]; then pm_web $2
fi