# CyberMonk

I was looking for a simple and quick way to start a little blog.
Perverably cheaply (free) hosted.

I quickly found out that you need a static website.
Best solution is *Jekyll*.

But I like Haxe, so I was looking for someone who had the same idea.

I found it: [Tong](http://blog.disktree.net/) and his Blog generator tool [Cyberchrist](https://github.com/tong/cyberchrist)
Sadly the project doesn't work out-of-the-box, so I need to rewrite/refector/recode.

That is also the reason I renamed the project.


## CyberMonk version

Based upon the excellent work of Tong, I start with cyberchrist version 0.3.2
but, because of some rewriting, the first version of CyberMonk will be 0.4.0.


## Haxe

The project is written in [Haxe](http://haxe.org/) and copiled to Neko

if you want to compile it yourself you need to install (besides Haxe) the next libs:

```
haxelib install markdown
haxelib install mconsole
```

## Sources used

An icon from [flaticon.com](http://www.flaticon.com/free-icon/feather-outline_43793)

Haxe (lib) Markdown  
[https://github.com/dpeek/haxe-markdown](https://github.com/dpeek/haxe-markdown)

For styling I am using Basscss  
[https://github.com/jxnblk/basscss](https://github.com/jxnblk/basscss)  
[http://www.basscss.com/](http://www.basscss.com/)

Haxe templates
[http://old.haxe.org/doc/cross/template](http://old.haxe.org/doc/cross/template)


## Structure
```
.
├── _config
├── _drafts
|   └── foobar.md
├── _layout
|   ├── index.html
|   └── post.html
├── _posts
|   └── 2015-10-14-test-me.md
└── index.html
```


## How to use

Open terminal  
drag `cybermonk` into your terminal and press enter.

```
CyberMonk 0.4.0
     Usage : cybermonk <command>
     Commands :
          start : Start new project (default files and templates)
          build : Build project
          clean : Remove all generated files
          post : Create a post
          update : Update templates
          config : Print project config
          help : Print this help
          version : Print CyberMonk version

```