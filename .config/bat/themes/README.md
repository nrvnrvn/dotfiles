# Tokyonight themes for vim

## Install/Update

```sh
mkdir -p "$(bat --config-dir)/themes"

for theme in day night moon storm; do
  curl -fsSo "$(bat --config-dir)/themes/tokyonight_${theme}.tmTheme" "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_${theme}.tmTheme"
done

bat cache --build
```
