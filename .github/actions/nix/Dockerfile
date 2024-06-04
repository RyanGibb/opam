FROM nixos/nix
RUN nix-channel --update
RUN nix-env -i gnum4 git rsync patch bzip2 gnumake wget ocaml ocaml5.1.1-ocaml-compiler-libs unzip gcc diffutils patch getconf-glibc gnused
RUN test -d /opam || mkdir /opam
ENV OPAMROOTISOK=1
ENV OPAMROOT=/opam/root
ENV OPAMYES=1
ENV OPAMCONFIRMLEVEL=unsafe-yes
ENV OPAMPRECISETRACKING=1
COPY opam /usr/bin/opam
RUN echo 'default-invariant: [ "ocaml" {>= "4.09.0"} ]' > /opam/opamrc
RUN /usr/bin/opam init --no-setup --disable-sandboxing --bare --config /opam/opamrc git+https://github.com/ocaml/opam-repository/#ca7f74d624024c73a7297ea2b022ef88d65b1121
RUN echo 'archive-mirrors: "https://opam.ocaml.org/cache"' >> $OPAMROOT/config
RUN /usr/bin/opam switch create this-opam --formula='"ocaml" {>= "4.09.0"}'
RUN nix-shell -p binutils --run "/usr/bin/opam install opam-core opam-state opam-solver opam-repository opam-format opam-client --deps"
RUN /usr/bin/opam clean -as --logs
COPY entrypoint.sh /opam/entrypoint.sh
ENTRYPOINT ["nix-shell", "-p", "binutils", "--run", "/opam/entrypoint.sh"]
