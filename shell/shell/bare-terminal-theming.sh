#!/bin/sh
#
# bare-terminal-theming.sh - sets colors for bare linux terminal

if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0282828
  \e]P1ee5396
  \e]P225be6a
  \e]P308bdba
  \e]P478a9ff
  \e]P5be95ff
  \e]P633b1ff
  \e]P7dfdfe0
  \e]P8484848
  \e]P9f16da6
  \e]PA46c880
  \e]PB2dc7c4
  \e]PC8cb6ff
  \e]PDc8a5ff
  \e]PE52bdff
  \e]PFe4e4e5
  "
  # get rid of artifacts
  clear
fi

