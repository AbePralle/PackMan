#!/bin/sh

HOME="/opt/morlock"
if ! [ -d "$HOME" ]; then
  echo --------------------------------------------------------------------------------
  echo Installing Morlock
  echo --------------------------------------------------------------------------------
  echo Creating home folder: $HOME
  mkdir "$HOME" &> /dev/null
  if ! [ -d "$HOME" ]; then
    echo '> sudo mkdir' "$HOME"
    sudo mkdir "$HOME"
  fi
fi

GROUP=""
if ! chown $USER$GROUP "$HOME" &> /dev/null; then
  echo '>' sudo chown $USER$GROUP "$HOME"
  sudo chown $USER$GROUP "$HOME"
fi

mkdir -p "$HOME/build/abepralle/morlock"
if ! [ -f "$HOME/build/abepralle/morlock/download-v2.success" ]; then
  echo Downloading Morlock bootstrap source...
  curl -fsSL https://raw.githubusercontent.com/AbePralle/Morlock/main/Source/Bootstrap/Morlock.h \
    -o "$HOME/build/abepralle/morlock/Morlock.h"
  curl -fsSL https://raw.githubusercontent.com/AbePralle/Morlock/main/Source/Bootstrap/Morlock.c \
    -o "$HOME/build/abepralle/morlock/Morlock.c"
  echo success >> "$HOME/build/abepralle/morlock/download-v2.success"
fi

if ! [ -f "$HOME/build/abepralle/morlock/compile-v2.success" ]; then
  echo Compiling Morlock bootstrap...
  if cc -O3 -Wall -fno-strict-aliasing \
    "$HOME/build/abepralle/morlock/Morlock.c" \
    -o "$HOME/build/abepralle/morlock/morlock"; then
    chmod a+x "$HOME/build/abepralle/morlock/morlock"
    echo success >> "$HOME/build/abepralle/morlock/compile-v2.success"
  fi
fi

echo Bootstrapping Morlock...
"$HOME/build/abepralle/morlock/morlock"

