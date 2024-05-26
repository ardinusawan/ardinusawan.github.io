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
asciinema: true
---

# Permasalahan

## Mengulang kembali apapun yang sudah dilakukan
```sh
git reflog
```

Git reflog (reference log) menyimpan catatan dari semua perubahan referensi di repository, termasuk HEAD, branches, dan remotes. Reflog memungkinkan untuk melihat riwayat perubahan dan memulihkan commit yang mungkin tidak lagi terhubung ke referensi yang lebih jelas.

Contoh
```sh
ac88bcf (HEAD -> main, origin/main, staging) HEAD@{0}: checkout: moving from staging to main
ac88bcf (HEAD -> main, origin/main, staging) HEAD@{1}: checkout: moving from main to staging
ac88bcf (HEAD -> main, origin/main, staging) HEAD@{2}: pull --rebase: Fast-forward
36ef154 HEAD@{3}: checkout: moving from dashboard to main
156ad31 (origin/dashboard, dashboard) HEAD@{4}: commit: fix build
b4c0e21 HEAD@{5}: reset: moving to HEAD
```

Jika ingin balik ke keadaan sebelum `pull --rebase`, maka cari head sebelumnya
```sh
git reset HEAD@{3}
```

Kamu dapat menggunakan 
```
git reset HEAD@{index}
```
atau
```
git reset --hard HEAD@{index}
```
Apa perbedaannya?

### `git reset --hard HEAD@{1}`

Jika kamu ingin benar-benar mengembalikan repository ke keadaan persis seperti commit HEAD@{1} dan membuang semua perubahan yang belum dikomit atau distage:
```sh
git reset --hard HEAD@{1}
```

### `git reset HEAD@{1}`

Jika kamu ingin mengembalikan staging area ke commit HEAD@{1} tetapi tetap menjaga perubahan yang ada di working directory (misalnya untuk memeriksa atau menyimpan sementara perubahan yang ada):
```sh
git reset HEAD@{1}
```

### Kesimpulan
`git reset --hard`: Mengembalikan repository sepenuhnya ke commit yang ditentukan, termasuk staging area dan working directory.

`git reset`: Mengembalikan commit yang ditentukan hanya untuk staging area, tidak mengubah working directory.

## Memperbaiki commit terakhir
```
git add . # Atau menambahkan file individu
git commit --amend --no-edit
```
{{< asciinema key="git-fu/amend-no-edit" >}}

- `--amend` artinya merubah.
- `--no-edit` artinya tanpa edit

Merubah tanpa edit? Tapi barusan kita mengedit isi commit sebelumnnya?

*ammend* ini adalah untuk commit message, bukan isinya. Masih belum paham?

## Memperbaiki pesan commit terakhir
```
git commit --amend
```
{{< asciinema key="git-fu/amend" >}}

Disini tanpa menggunakan  `--no-edit`, jadi hanya mengganti pesan *commit*nya saja. Sudah jelas kan?

## Tanpa sengaja membuat commit di branch yang salah
Pernah ga sih lupa checkout ke branch tetapi langsung ngoding di branch master? 🤣

Tenang, caranya gampang banget.
### git reset HEAD~ --hard
1. Pada branch master, buat dulu branch baru
    ```sh
    git branch nama-branch-baru
    ```
1. Reset master ke commit sebelumnya
    ```sh
    git reset HEAD~ --hard
    ```
1. Checkout ke branch yang benar
    ```sh
    git branch nama-branch-baru
    
    ```
{{< asciinema key="git-fu/drop-one-commit-wrong-branch" >}}

### git rebase -i HEAD~n
Cara yang tadi berlaku jika hanya ada 1 commit yang di reset. Tapi kalo terlanjur banyak commit di master, gimana dong?

Langkah yang berbeda hanya pada *step* ke 2

1. Drop commit yang ingin dihapus
    ```sh
    git rebase -i HEAD~n # n adalah perkiraan berapa commit yang ingin di hapus
    ```
1. Pada editor, cari commit mana yang ingin di hapus. Ubah `pick` ke `drop`. Lalu simpan.

{{< asciinema key="git-fu/drop-many-commit-wrong-branch" >}}

Jika commit pada master sudah terlanjur di push, bagaimana?

Harus di force push 😢. Maka dari itu, *branch* master/main harus di *guard* agar tidak bisa commit langsung ya, hanya dapat di merge dari branch lain.

Untuk cara force push akan ada penjelasannya tersendiri.

# Sumber Referensi
- ["Oh Shit, Git!?!"](https://ohshitgit.com/)
