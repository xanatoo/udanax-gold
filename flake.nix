{
  description = "Udanax Gold: incremental recovery of the original build";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems
        (system: f (import nixpkgs { inherit system; }));
    in {
      packages = forAllSystems (pkgs:
        let
          ccompat = pkgs.stdenv.mkDerivation {
            pname = "udanax-gold-ccompat";
            version = "0.1";
            src = ./.;

            # Build a genuine piece of the 1993 C compatibility layer first.
            # Its own test executable is independent of X++, stubble and xumake.
            dontConfigure = true;
            nativeBuildInputs = [ pkgs.binutils ];

            buildPhase = ''
              runHook preBuild
              mkdir -p build
              $CC -std=gnu89 -O2 -Isrc/xpp \
                -c src/xpp/ccompatc.c -o build/ccompatc.o
              $CC -std=gnu89 -O2 -Isrc/xpp \
                src/xpp/ccompatt.c build/ccompatc.o -o build/ccompatt
              $AR rcs build/libudanax-ccompat.a build/ccompatc.o
              runHook postBuild
            '';

            doCheck = true;
            checkPhase = ''
              runHook preCheck
              ./build/ccompatt > build/test.stdout 2> build/test.stderr
              grep -Fx 'CAT(foo,bar)' build/test.stderr
              grep -Fx 'foobar' build/test.stderr
              runHook postCheck
            '';

            installPhase = ''
              runHook preInstall
              install -Dm755 build/ccompatt "$out/bin/udanax-ccompat-test"
              install -Dm644 build/libudanax-ccompat.a "$out/lib/libudanax-ccompat.a"
              install -Dm644 src/xpp/ccompatc.h "$out/include/udanax/ccompatc.h"
              runHook postInstall
            '';

            meta = {
              description = "Original Udanax Gold C compatibility library and smoke test";
              platforms = pkgs.lib.platforms.linux;
            };
          };
        in {
          default = ccompat;
          inherit ccompat;
        });

      checks = forAllSystems (pkgs: {
        ccompat = self.packages.${pkgs.stdenv.hostPlatform.system}.ccompat;
      });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.ccompat}/bin/udanax-ccompat-test";
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [ gcc gnumake binutils gdb ];
        };
      });
    };
}
