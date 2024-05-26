---
author: ["I Dewa Putu Ardi Nusawan"]
title: "Git-fu"
date: 2024-05-26
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
draft: false
asciinema: true
---

# Permasalahan

## Mengulang kembali apapun yang sudah dilakukan

Bayangkan Anda telah melakukan beberapa commit, tetapi kemudian Anda melakukan `git reset --hard HEAD~2` dan kehilangan dua commit terakhir. Anda dapat memulihkannya dengan cara berikut:

{{< asciinema key="git-fu/reflog" >}}

1. Cek log reflog
```sh
git reflog
```
1. Outputnya mungkin menunjukkan:
```sh
c4f2a27 (HEAD -> main) HEAD@{0}: reset: moving to HEAD~2
a3d5b8e HEAD@{1}: commit: Menambahkan file README
```
1. Anda ingin mengembalikan commit a3d5b8e:
```sh
git reset --hard a3d5b8e
```

Untuk memulihkan, kamu dapat menggunakan 
```sh
git reset HEAD@{index}
```
atau
```sh
git reset --hard HEAD@{index}
```

**Apa perbedaannya?**

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

----

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

----

## Memperbaiki pesan commit terakhir
```
git commit --amend
```
{{< asciinema key="git-fu/amend" >}}

Disini tanpa menggunakan  `--no-edit`, jadi hanya mengganti pesan *commit*nya saja. Sudah jelas kan?

----

## Tanpa sengaja membuat commit di branch master, harusnya di branch baru
Pernah ga sih lupa checkout ke branch tetapi langsung ngoding di branch master(atau branch lainnya)? 🤣

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

### git cherry-pick commit-hash

Ada cara yang lebih simple dan lebih sering saya gunakan, `cherry-pick`
```sh
git cherry-pick commit-hash
```
{{< asciinema key="git-fu/cherry-pick" >}}

Setelah melakukan *cherry pick*, dapat checkout kembali ke branch yang salah dan melalukan `git reset HEAD~ --hard` atau `git rebase -i HEAD~n`

### Catatan

Jika commit pada master sudah terlanjur di push, bagaimana?

Harus di force push 😢. Maka dari itu, *branch* master/main harus di *guard* agar tidak bisa commit langsung ya, hanya dapat di merge dari branch lain.

Untuk cara force push akan ada penjelasannya tersendiri.

----

## Membatalkan *commit* yang lampau

```sh
git revert [saved hash]
```
{{< asciinema key="git-fu/revert" >}}

Perbedaan revert dengan `rebase -> drop` atau `reset --hard`, revert membentuk commit baru. Jadi nanti kamu bisa *revert* commit yang me-*revert* commit 🤣

Jika ditengah proses rebase ingin membatalkan, gunakan `git rebase --abort`

----

## Menyimpan state

```sh
git stash save "stash name"
```

Mirip ketika bermain game dan menyimpan *save*, pada saat ngoding kita dapat menyimpan *state* saat ini dan men-*load* kemudian

{{< asciinema key="git-fu/stash" >}}

1. *stash* state
    ```sh
    git stash save "nama custom" # nama stash opsional
    ```
    Jika tanpa nama *custom*
        ```sh
        git stash save
        ```
1. List stash
    ```sh
    git stash list
    ```
1. *Load* state
    ```sh
    git stash apply stash@{n} # n: posisi stash yang didapatkan pada stash list
    ```
    Jika tanpa `stash@{n}`
    ```sh
    git stash apply
    ```
    Maka akan *load stash* trakhir. Perintah ini sama dengan `git stash apply stash@{0}`

----

## Mengembalikan keadaan file pada keadaan sebelumnya

```sh
git checkout [hash] -- path/to/file
```

Membantu jika ingin mengembalikan kondisi file sesuai pada commit tertentu

{{< asciinema key="git-fu/checkout-commited" >}}

----

## Push Paksa (Force Push)
**Penjelasan kali ini akan lebih panjang, karena merupakan tindakan yang berbahaya!**

Force push (`git push --force`) adalah tindakan untuk memaksa mengirimkan perubahan dari repository lokal ke repository remote, menggantikan riwayat commit yang ada di remote. Ini berguna ketika Anda perlu memperbarui riwayat commit di remote setelah melakukan perubahan seperti `rebase` atau `amend`.

### Mengapa Force Push Berbahaya?

Force push bisa berbahaya karena:
- Menghapus riwayat commit di remote yang mungkin penting.
- Membuat commit rekan tim Anda hilang jika mereka juga bekerja pada branch yang sama.
- Menyebabkan konflik jika orang lain telah menggabungkan (merge) commit yang Anda ganti.

### `--force`

Misalkan Anda telah mengubah riwayat commit di branch `main` dengan melakukan rebase atau mengedit commit, dan Anda ingin memaksa mengupdate remote repository.

1. Buat beberapa perubahan dan lakukan commit:
    ```bash
    git commit --amend -m "Memperbaiki pesan commit"
    ```
1. Push perubahan dengan force:
    ```bash
    git push --force origin main
    ```

Dengan menggunakan `--force`, Anda menggantikan riwayat commit yang ada di remote dengan riwayat commit baru dari repository lokal Anda.

### `--force-with-lease`

`--force-with-lease` adalah opsi yang lebih aman daripada `--force` karena melakukan pemeriksaan tambahan sebelum melakukan push. Opsi ini memastikan bahwa Anda hanya akan memaksa push jika tidak ada orang lain yang telah melakukan push ke remote sejak Anda terakhir kali menarik (pull) perubahan.

#### Keuntungan Menggunakan `--force-with-lease`

- Mencegah Anda secara tidak sengaja menimpa commit orang lain.
- Memberikan peringatan jika terdapat perubahan di remote yang belum Anda tarik (pull).

#### Contoh Penggunaan `--force-with-lease`

Misalkan Anda melakukan perubahan di branch `main` dan ingin memastikan tidak ada yang telah melakukan push ke remote sejak terakhir kali Anda menarik perubahan.

1. Buat beberapa perubahan dan lakukan commit:
    ```bash
    git commit --amend -m "Memperbaiki pesan commit"
    ```
1. Push perubahan dengan `--force-with-lease`:
    ```bash
    git push --force-with-lease origin main
    ```

Jika tidak ada orang lain yang melakukan push ke branch `main` di remote, perubahan Anda akan diterima. Namun, jika ada perubahan di remote yang belum Anda tarik, Git akan memberikan peringatan dan menghentikan push tersebut, mencegah potensi konflik.

### Kesimpulan

Dengan menggunakan `--force-with-lease`, Anda mendapatkan perlindungan tambahan dibandingkan `--force`, sehingga lebih aman untuk digunakan dalam lingkungan kolaboratif. Selalu berhati-hati saat menggunakan force push untuk menghindari kehilangan riwayat commit yang penting.

# Sumber Referensi
- ["Oh Shit, Git!?!"](https://ohshitgit.com/)

# Peralatan
- Editor [neovim](https://github.com/neovim/neovim)
- Terminal direkam dengan [asciinema](https://github.com/asciinema/asciinema)
- Pemutar menggunakan [asciinema-player](https://github.com/asciinema/asciinema-player)
- Git interface [tig](https://github.com/jonas/tig)
