# ping
ping:
    echo "pong"

# ask the read-only research agent a one-shot question
research question:
    goose run --recipe research --params task={{ quote(question) }} --no-session --max-turns 30

# interactive chat with the read-only research agent
research-chat:
    goose run --recipe research -s
