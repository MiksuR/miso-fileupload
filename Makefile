
.PHONY= update build optim

all: clean update build optim

update:
	wasm32-wasi-cabal update

build:
	wasm32-wasi-cabal build client
	rm -rf public
	cp -r static public
	$(eval my_wasm=$(shell wasm32-wasi-cabal list-bin client | tail -n 1))
	$(shell wasm32-wasi-ghc --print-libdir)/post-link.mjs --input $(my_wasm) --output public/ghc_wasm_jsffi.js
	cp -v $(my_wasm) public/

optim:
	wasm-opt -all -O2 public/client.wasm -o public/client.wasm
	wasm-tools strip -o public/client.wasm public/client.wasm

serve:
	cabal run server

clean:
	rm -rf dist-newstyle public

