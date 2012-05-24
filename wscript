#!/usr/bin/env python

from waflib import *

# Looks for Flambe in your installed haxelibs
def flambe_path(ctx):
    try: return ctx.cmd_and_log("haxelib path flambe", quiet=Context.BOTH).split("\n")[0];
    except Errors.WafError: ctx.fatal("Could not find Flambe, run `haxelib install flambe`.")

# Setup options for display when running waf --help
def options(ctx):
    ctx.load("flambe", tooldir=flambe_path(ctx)+"/tools")

# Setup configuration when running waf configure
def configure(ctx):
    ctx.load("flambe", tooldir=flambe_path(ctx)+"/tools")

# Runs the build!
def build(ctx):
    platforms = ["flash", "html"]

    # Kick off a build with the desired platforms
    ctx(features="flambe",
        platforms=platforms,
        main="novella.NovellaMain")
