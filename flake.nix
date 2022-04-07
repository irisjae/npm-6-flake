{
description = "npm v6";

inputs =
	{
	flake-utils = { url = "github:numtide/flake-utils"; };
	nix-npm-buildpackage = { url = "github:serokell/nix-npm-buildpackage"; };
	};

outputs =
	{ self, flake-utils, nix-npm-buildpackage, nixpkgs }:
		flake-utils .lib .eachDefaultSystem
		(
		system:
			let
			pkgs = nixpkgs .legacyPackages .${system};
			bp = pkgs .callPackage nix-npm-buildpackage {};
			npm-6-node-modules = bp .mkNodeModules { src = ./.; pname = "npm"; version = "6"; packageOverrides = {}; };
			npm-6 =
				pkgs .stdenv .mkDerivation
				(
				{
				name = "npm-6";
				unpackPhase = "true";
				buildPhase = "";
				installPhase = "mkdir -p $out/bin; ln -s ${npm-6-node-modules}/node_modules/.bin/npm $out/bin;";
				} );
			in
			{ defaultPackage = npm-6; } );
}
