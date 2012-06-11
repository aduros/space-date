#!/usr/bin/env python

# Setup options for display when running waf --help
def options(ctx):
    ctx.load("flambe")

# Setup configuration when running waf configure
def configure(ctx):
    ctx.load("flambe")

# Runs the build!
def build(ctx):
    platforms = ["flash", "html"]

    # Kick off a build with the desired platforms
    ctx(features="flambe",
        platforms=platforms,
        main="novella.NovellaMain")
