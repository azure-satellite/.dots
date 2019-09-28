#!/usr/bin/env bash

set -e
shopt -s nullglob

maildirs=$(find $DIR/* -maxdepth 0 -type d)

output_stats() {
    out=""
    for maildir in $maildirs; do
        unread=$(find $maildir/Inbox/{new,cur} -type f | grep -vE ',[^,]*S[^,]*$' | wc -l)
        base="$(basename $maildir)"
        if [[ $unread > 0 ]]; then
            out+="$base ($unread) — "
        fi
    done
    if [[ -n $out ]]; then
        echo "<span foreground='#ffff00'> ${out:0:(-3)}</span>"
    else
        echo " — "
    fi
}

towatch=$(find $DIR/* -maxdepth 1 -type d -name Inbox -exec echo -n "{}/new {}/cur " \;)

output_stats
inotifywait -q -m -e create,delete,move $towatch | while read event; do output_stats; done

shopt -u nullglob
