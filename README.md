# :ramen: 📁⬆️ miso-fileupload

This fork of [miso-filereader](https://github.com/haskell-miso/miso-filereader)
connects to a Servant server that receives file uploads.

## Build and run

Install [Nix Flakes](https://nixos.wiki/wiki/Flakes), then:

```
nix develop .#wasm
make
make serve
```

