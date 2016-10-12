#!/usr/bin/env bash
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Source aliases
if [ -f ~/utilities/.aliases ]; then
        . ~/utilities/.aliases
fi

# User specific aliases and functions
export GOPATH="/home/developer/content_router"
