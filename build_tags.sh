#!/bin/sh
etags --language=none --regex='/\([^ \t]+\)[ \t]*<-[ \t]*function/\1/' *.R
