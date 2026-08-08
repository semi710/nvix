set positional-arguments

# Serve docs locally (http://0.0.0.0:<random-port>)
doc:
    PORT=$(shuf -i 8000-9000 -n 1) && echo "→ http://0.0.0.0:$PORT" && nix run .#docs -- serve -a 0.0.0.0:$PORT --quiet 2>&1 | grep -v "│"

# Run a variant (bare, core, or full)
run variant="core":
    nix run .#{{variant}}

# Build a variant (bare, core, or full)
build variant="core":
    nix build .#{{variant}}

# Format nix files
fmt:
    treefmt

# Update flake lock
update:
    nix flake update

# Check flake (eval all configs)
check:
    nix flake check

# Garbage collect — all profiles (needs sudo)
gc:
    sudo nh clean all
