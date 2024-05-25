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

### Menggunakan `git reset --hard HEAD@{1}`

Jika kamu ingin benar-benar mengembalikan repository ke keadaan persis seperti commit HEAD@{1} dan membuang semua perubahan yang belum dikomit atau distage:
```sh
git reset --hard HEAD@{1}
```

### Menggunakan `git reset HEAD@{1}`

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
git commit --ammend --no-edit
```
{{< asciinema key="git-fu/2-ammend-no-edit" >}}


# Sumber Referensi
- ["Oh Shit, Git!?!"](https://ohshitgit.com/)
