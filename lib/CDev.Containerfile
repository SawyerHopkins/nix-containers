FROM nixos/nix

ENV NIX_CONFIG="experimental-features = nix-command flakes"

RUN nix-channel --update

WORKDIR /cdev
COPY flake.* /cdev
RUN nix build .#start-sshd --out-link /cdev/out

RUN nix develop --command true

EXPOSE 22
ENTRYPOINT ["/cdev/out/bin/start-sshd"]