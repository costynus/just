# ping
ping:
    echo "pong"

# ask the read-only research agent a one-shot question
research question:
    goose run --recipe research --params task={{ quote(question) }} --no-session --max-turns 30

# interactive chat with the read-only research agent
research-chat:
    goose run --recipe research -s

# review the working tree with goose and pretty-print the findings (like the greview shell function)
# extra arguments are passed through to goose review, e.g.: just greview --range main...HEAD
greview *args:
    #!/bin/sh
    _start=$(date +%s)
    goose review {{args}} | jq -Rrs -f greview.jq
    _elapsed=$(( $(date +%s) - _start ))
    _min=$(( _elapsed / 60 ))
    _sec=$(( _elapsed % 60 ))
    if [ "$_min" -gt 0 ]; then
        printf '\n\033[2mReview completed in %dm %ds\033[0m\n' "$_min" "$_sec"
    else
        printf '\n\033[2mReview completed in %ds\033[0m\n' "$_sec"
    fi

# quick review: the same, but each agent is capped at 3 turns (like the greview-lite shell function)
greview-lite *args:
    #!/bin/sh
    _start=$(date +%s)
    goose review --turn-limit 3 {{args}} | jq -Rrs -f greview.jq
    _elapsed=$(( $(date +%s) - _start ))
    _min=$(( _elapsed / 60 ))
    _sec=$(( _elapsed % 60 ))
    if [ "$_min" -gt 0 ]; then
        printf '\n\033[2mReview completed in %dm %ds\033[0m\n' "$_min" "$_sec"
    else
        printf '\n\033[2mReview completed in %ds\033[0m\n' "$_sec"
    fi
