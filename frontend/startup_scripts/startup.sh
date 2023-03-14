#!/bin/sh

python3 /home/register.py frontend &
apache2ctl -D FOREGROUND