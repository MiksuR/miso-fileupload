# :ramen: 📁⬆️ miso-fileupload

This fork of [miso-filereader](https://github.com/haskell-miso/miso-filereader)
connects to a Servant server that receives file uploads.

## Develop

Running the development environment requires [Nix Flakes](https://nixos.wiki/wiki/Flakes).

The client can be run with hot-reload by typing

```
nix develop
ghcid -c 'cabal repl client' -T=Main.main
```

The server can be run with

``` 
nix develop
cabal repl server
```
