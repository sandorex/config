#!/usr/bin/env bash

# set window title buttons like so | icon on_top      minimize maximize close |
kwriteconfig5 --file "$HOME/.config/kwinrc" --group org.kde.kdecoration2 --key ButtonsOnRight --delete
kwriteconfig5 --file "$HOME/.config/kwinrc" --group org.kde.kdecoration2 --key ButtonsOnLeft 'MF'
