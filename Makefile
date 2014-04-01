.PHONY: bench build configure haddock hpc install repl run test

all: install configure build haddock test hpc bench

bench:
	cabal bench

build:
	cabal build

clean:
	cabal clean
	if test -d .cabal-sandbox; then cabal sandbox delete; fi
	if test -d .hpc; then rm -r .hpc; fi
	if test -e tmp/*.html; then rm tmp/*.html; fi

configure:
	cabal configure --enable-benchmarks --enable-tests

format:
	git ls-files '*.hs' | xargs -n 1 scan --inplace-modify
	git ls-files '*.hs' | xargs stylish-haskell --inplace

haddock:
	cabal haddock --hyperlink-source
	# dist/doc/html/hs2048/index.html

hpc:
	hpc markup --destdir=tmp dist/hpc/tix/hspec/hspec.tix
	# tmp/hpc_index.html

install:
	cabal sandbox init
	cabal install --enable-benchmarks --enable-tests --flags=documentation --only-dependencies --reorder-goals

repl:
	cabal repl lib:hs2048

run:
	cabal run hs2048

test:
	cabal test
