task default -depends cleanup

task stuff {
    echo "is some stuff" > .\stuff.txt
}

task test -depends stuff {
    if (cat .\stuff.txt | sls "Here") {
        echo "'Here' is in the file"
    } else {
        echo "Putting 'Here' in the file"
        echo "Here" >> .\stuff.txt
    }
}

task cleanup -depends test {
    mv .\stuff.txt ".\stuff.txt.$((get-date).Ticks)"
}