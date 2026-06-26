set positional-arguments

# Deploy — current host (no arg) or remote host over SSH
deploy host="":
    @if [ -z "{{host}}" ]; then \
        if [ "$(uname -s)" = "Darwin" ]; then \
            nh darwin switch . -H jp-mbp; \
        else \
            nh os switch .; \
        fi; \
    else \
        case "{{host}}" in \
            obox) \
                nh os switch .#obox --target-host nikhil@obox --build-host nikhil@obox --elevation-strategy passwordless ;; \
            mach) \
                nh os switch .#mach --target-host niksingh710@mach --elevation-strategy passwordless ;; \
            *) \
                nh os switch .#{{host}} --target-host nikhil.singh@{{host}} --elevation-strategy passwordless ;; \
        esac; \
    fi

# Deploy home-manager only (run on the target machine after SSH)
home user="nikhil":
    nh home switch .#{{user}}

# Dry build (eval only, no compilation)
build host:
    @case "{{host}}" in \
        jp-mbp) nh darwin build . -H jp-mbp --dry ;; \
        *) nh os build .#{{host}} --dry ;; \
    esac

# Build ISO
iso:
    nix build .#iso

# Serve docs locally (http://0.0.0.0:<random-port>)
doc:
    PORT=$(shuf -i 8000-9000 -n 1) && echo "→ http://0.0.0.0:$PORT" && nix run .#docs -- serve -a 0.0.0.0:$PORT --quiet 2>&1 | grep -v "│"

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
