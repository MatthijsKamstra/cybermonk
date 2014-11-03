# CyberMonk

I was looking for a simple and quick way to start a little blog.
Preverably cheaply (free) hosted.

I quickly found out that you could do that on github and you need a static website.
Best blogging solution is *Jekyll*.

But for all my hobby projects I us Haxe, so I was looking for someone who had the same idea and did the heavy lifting for me.

Haxe has a very active communinity so it was not that difficult to find: [Tong](http://blog.disktree.net/) created [Cyberchrist](https://github.com/tong/cyberchrist) a _Blog generator tool_.   
Sadly the project doesn't work out-of-the-box, so I need to rewrite/refector/recode.

That is also the reason I renamed the project to CyberMonk.


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

Read more about Markdown
[http://daringfireball.net/projects/markdown/](http://daringfireball.net/projects/markdown/) 

Mou - Markdown editor for developers.
[Mou](http://25.io/mou/)



## Structure
```
.
├── _config.json
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
CyberMonk 0.4.2
     Usage : cybermonk <command>
     Commands :
          start : Start new project (default files and templates)
          build : Build project
          clean : Remove all generated files
          convertimage : Generate markdown files from _img folder
          post : Create a post
          update : Update templates
          config : Print project config
          help : Print this help
          version : Print CyberMonk version

```