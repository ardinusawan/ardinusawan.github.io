---
author: ["I Dewa Putu Ardi Nusawan"]
title: "Git-fu"
date: 2024-05-19
description: "Belajar git untuk mempermudah hidupmu"
tags: ["git"]
thumbnail:
  image: "https://media.dev.to/cdn-cgi/image/width=1000,height=420,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fi%2Fnsbbm80zgqqypxyqtx1d.png"
cover:
  image: "https://media.dev.to/cdn-cgi/image/width=1000,height=420,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fi%2Fnsbbm80zgqqypxyqtx1d.png"
  alt: "Git"
  caption: "Git"
  relative: true
ShowToc: true
comments: true
draft: true
---

# Pengenalan
Git, 'benda' yang setiap hari digunakan oleh dev namun seringkali diabaiakan 😞

Mau sampai kapan clone branch baru kalo `git rebase` bikin frustasi?? 😛

Oiya, disini saya akan menggunakan MacOS, jadi untuk pengguna UNIX-like (linux) dapat meniru langkah demi langkah, namun untuk pengguna windows dapat menggunakan menyesuaikan sendiri ya

# Perintah

## Init
```sh
git init
```
Langkah paling pertama yang dilakukan untuk *menginisiasi* git.

Langkahnya
1. Buat folder kosong
    ```sh
    mkdir test
    ```
1. Masuk ke folder, lalu jalankan perintah
    ```sh
    cd test
    git init
    ```
1. Git akan membuat folder `.git`. Folder ini berisikan metadata dan object data. Waduh apaan nih?
### Komponen
```
➜  ardinusawan.xyz git:(main) ✗ ls -lah .git
total 88
drwxr-xr-x   15 ardinusawan  staff   480B May 18 11:02 .
drwxr-xr-x   18 ardinusawan  staff   576B May 16 20:33 ..
-rw-r--r--    1 ardinusawan  staff   1.1K May 18 11:02 COMMIT_EDITMSG
-rw-r--r--    1 ardinusawan  staff   104B May 15 19:58 FETCH_HEAD
-rw-r--r--    1 ardinusawan  staff    21B May 16 23:09 HEAD
-rw-r--r--    1 ardinusawan  staff    41B May 16 00:39 ORIG_HEAD
-rw-r--r--    1 ardinusawan  staff   421B Feb  4 23:08 config
-rw-r--r--    1 ardinusawan  staff    73B Feb  4 21:32 description
drwxr-xr-x   16 ardinusawan  staff   512B Feb  4 21:32 hooks
-rw-r--r--    1 ardinusawan  staff    16K May 18 11:02 index
drwxr-xr-x    3 ardinusawan  staff    96B Feb  4 21:32 info
drwxr-xr-x    4 ardinusawan  staff   128B Feb  4 23:07 logs
drwxr-xr-x    3 ardinusawan  staff    96B Feb  4 21:32 modules
drwxr-xr-x  242 ardinusawan  staff   7.6K May 18 11:02 objects
drwxr-xr-x    6 ardinusawan  staff   192B May 16 00:39 refs
```
1. COMMIT_EDITMSG
    - Mengandung pesan commit terakhir and daftar perubahan pada file (jika ada)
    <details>
        <summary>Contoh</summary>

        ➜  ardinusawan.xyz git:(main) ✗ cat .git/COMMIT_EDITMSG
        Add neovim-ftw draft
        # Please enter the commit message for your changes. Lines starting
        # with '#' will be ignored, and an empty message aborts the commit.
        #
        # On branch main
        # Your branch is up to date with 'origin/main'.
        #
        # Changes to be committed:
        #       modified:   content/posts/auth-multi-platform/index.md
        #       modified:   content/posts/git-fu/index.md
        #       new file:   content/posts/neovim-ftw/index.md
        #       modified:   content/posts/website-in-pi/index.md
        #       modified:   public/index.html
        #       modified:   public/index.json
        #       modified:   public/index.xml
        #       modified:   public/posts/auth-multi-platform/index.html
        #       new file:   public/posts/freedom-with-neovim/index.html
        #       modified:   public/posts/git-fu/index.html
        #       new file:   public/posts/neovim-ftw/index.html
        #       modified:   public/posts/website-in-pi/index.html
        #       new file:   public/tags/neovim/index.html
        #       new file:   public/tags/neovim/index.xml
        #       new file:   public/tags/neovim/page/1/index.html
        #       new file:   public/tags/vim/index.html
        #       new file:   public/tags/vim/index.xml
        #       new file:   public/tags/vim/page/1/index.html
    </details>
1. FETCH_HEAD

1. HEAD
   - Berisikan referensi (branch/commit/tag) yang sedang aktif saat ini
   ```
   ➜  ardinusawan.xyz git:(main) ✗ cat .git/HEAD
   ref: refs/heads/main
   ```
1. ORIG_HEAD
1. config
    - Berisikan config dari repository
    <details>
        <summary>Contoh</summary>

        ➜  ardinusawan.xyz git:(main) ✗ cat .git/config
        [core]
                repositoryformatversion = 0
                filemode = true
                bare = false
                logallrefupdates = true
                ignorecase = true
                precomposeunicode = true
        [submodule "themes/PaperMod"]
                url = https://github.com/adityatelange/hugo-PaperMod.git
                active = true
        [remote "origin"]
                url = git@github.com:ardinusawan/ardinusawan.github.io.git
                fetch = +refs/heads/*:refs/remotes/origin/*
        [branch "main"]
                remote = origin
                merge = refs/heads/main

    </details>
1. description
1. hooks
1. index
1. info
1. logs
1. modules
1. objects
1. refs

## Clone

## Pull
### Fast Forward (FF)

## Push
### Upstream

## Fetch

## Merge

## Rebase

## Stash

## Reflog

## Patch

## Submodule
