# CyberMonk

I have a blog, but I was looking for a simple and quick way to start a little blog without all the database

Based upon the excellent work of [Tong](http://blog.disktree.net/) and his Blog generator tool 
[Cyberchrist](https://github.com/tong/cyberchrist)

started with version cyberchrist 0.3.2
but, because of some rewriting, I guess it save to say this is (CyberMonk) 0.4.0



## Haxe

The project is written in [Haxe](http://haxe.org/) and copiled to Neko

if you want to compile it yourself you need to install the next libs:

```
haxelib install markdown
haxelib install mconsole
```

## Sources used

An icon from [flaticon.com](http://www.flaticon.com)

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
drag `CyberMonk` into your terminal

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