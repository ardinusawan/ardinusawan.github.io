---
author: ["I Dewa Putu Ardi Nusawan"]
title: "Git-fu"
date: 2024-05-26
description: "Learn git to make your life easier"
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

# Problems

## Reverting anything that has been done

Imagine you've made several commits, but then you run `git reset --hard HEAD~2` and lose the last two commits. You can restore them as follows:

{{< asciinema key="git-fu/reflog" >}}

1. Check reflog log
```sh
git reflog
```
1. The output might show:
```sh
c4f2a27 (HEAD -> main) HEAD@{0}: reset: moving to HEAD~2
a3d5b8e HEAD@{1}: commit: Menambahkan file README
```
1. You want to restore commit a3d5b8e:
```sh
git reset --hard a3d5b8e
```

To restore, you can use
```sh
git reset HEAD@{index}
```
or
```sh
git reset --hard HEAD@{index}
```

**What's the difference?**

### `git reset --hard HEAD@{1}`

If you want to completely restore the repository to the exact state of commit HEAD@{1} and discard all unstaged or uncommitted changes:
```sh
git reset --hard HEAD@{1}
```

### `git reset HEAD@{1}`

If you want to restore the staging area to commit HEAD@{1} but keep the changes in the working directory (for example, to check or temporarily save existing changes):
```sh
git reset HEAD@{1}
```

### Conclusion
`git reset --hard`: Completely restores the repository to the specified commit, including the staging area and working directory.

`git reset`: Restores the specified commit only for the staging area, doesn't change the working directory.

----

## Fixing the last commit
```
git add . # Or add individual files
git commit --amend --no-edit
```
{{< asciinema key="git-fu/amend-no-edit" >}}

- `--amend` means to modify.
- `--no-edit` means without edit

Modifying without edit? But we just edited the previous commit content?

*amend* is for the commit message, not its content. Still don't understand?

----

## Fixing the last commit message
```
git commit --amend
```
{{< asciinema key="git-fu/amend" >}}

Here without using `--no-edit`, so it only changes the *commit* message. Clear now?

----

## Accidentally committed on the master branch, should have been on a new branch
Ever forgot to checkout to a branch but directly coded on the master branch (or another branch)? 🤣

Don't worry, it's very easy.
### git reset HEAD~ --hard
1. On the master branch, create a new branch first
    ```sh
    git branch new-branch-name
    ```
1. Reset master to the previous commit
    ```sh
    git reset HEAD~ --hard
    ```
1. Checkout to the correct branch
    ```sh
    git branch new-branch-name
    
    ```
{{< asciinema key="git-fu/drop-one-commit-wrong-branch" >}}

### git rebase -i HEAD~n
The previous method applies if there's only 1 commit to reset. But if there are already many commits on master, what then?

The different step is only in step 2

1. Drop the commits you want to delete
    ```sh
    git rebase -i HEAD~n # n is the estimated number of commits you want to delete
    ```
1. In the editor, find which commit you want to delete. Change `pick` to `drop`. Then save.

{{< asciinema key="git-fu/drop-many-commit-wrong-branch" >}}

### git cherry-pick commit-hash

There's a simpler method that I use more often, `cherry-pick`
```sh
git cherry-pick commit-hash
```
{{< asciinema key="git-fu/cherry-pick" >}}

After doing *cherry pick*, you can checkout back to the wrong branch and do `git reset HEAD~ --hard` or `git rebase -i HEAD~n`

### Note

If the commits on master have already been pushed, what then?

Must force push 😢. Therefore, the master/main *branch* must be *guarded* so it can't be committed directly, only can be merged from other branches.

For the force push method, there will be a separate explanation.

----

## Reverting past commits

```sh
git revert [saved hash]
```
{{< asciinema key="git-fu/revert" >}}

The difference between revert and `rebase -> drop` or `reset --hard`, revert creates a new commit. So later you can *revert* the commit that *reverts* the commit 🤣

If in the middle of the rebase process you want to cancel, use `git rebase --abort`

----

## Saving state

```sh
git stash save "stash name"
```

Similar to when playing a game and saving the *save*, when coding we can save the current *state* and *load* it later

{{< asciinema key="git-fu/stash" >}}

1. *stash* state
    ```sh
    git stash save "custom name" # custom stash name is optional
    ```
    If without a *custom* name
        ```sh
        git stash save
        ```
1. List stash
    ```sh
    git stash list
    ```
1. *Load* state
    ```sh
    git stash apply stash@{n} # n: stash position obtained from stash list
    ```
    If without `stash@{n}`
    ```sh
    git stash apply
    ```
    Then it will *load the last stash*. This command is the same as `git stash apply stash@{0}`

----

## Restoring file to previous state

```sh
git checkout [hash] -- path/to/file
```

Helps if you want to restore the file condition according to a specific commit

{{< asciinema key="git-fu/checkout-commited" >}}

----

## Force Push
**This explanation will be longer because it's a dangerous action!**

Force push (`git push --force`) is an action to forcefully send changes from the local repository to the remote repository, replacing the existing commit history on the remote. This is useful when you need to update the commit history on the remote after making changes like `rebase` or `amend`.

### Why Force Push is Dangerous?

Force push can be dangerous because:
- Deletes commit history on the remote that might be important.
- Makes your team members' commits disappear if they're also working on the same branch.
- Causes conflicts if others have merged the commits you changed.

### `--force`

Suppose you've changed the commit history on the `main` branch by doing a rebase or editing commits, and you want to forcefully update the remote repository.

1. Make some changes and commit:
    ```bash
    git commit --amend -m "Fixing commit message"
    ```
1. Push changes with force:
    ```bash
    git push --force origin main
    ```

By using `--force`, you replace the existing commit history on the remote with the new commit history from your local repository.

### `--force-with-lease`

`--force-with-lease` is a safer option than `--force` because it performs additional checks before pushing. This option ensures that you'll only force push if no one else has pushed to the remote since you last pulled (pull) changes.

#### Advantages of Using `--force-with-lease`

- Prevents you from accidentally overwriting others' commits.
- Gives a warning if there are changes on the remote that you haven't pulled (pull) yet.

#### Example of Using `--force-with-lease`

Suppose you make changes on the `main` branch and want to ensure no one has pushed to the remote since you last pulled changes.

1. Make some changes and commit:
    ```bash
    git commit --amend -m "Fixing commit message"
    ```
1. Push changes with `--force-with-lease`:
    ```bash
    git push --force-with-lease origin main
    ```

If no one has pushed to the `main` branch on the remote, your changes will be accepted. However, if there are changes on the remote that you haven't pulled, Git will give a warning and stop the push, preventing potential conflicts.

### Conclusion

By using `--force-with-lease`, you get additional protection compared to `--force`, making it safer to use in collaborative environments. Always be careful when using force push to avoid losing important commit history.

# References
- ["Oh Shit, Git!?!"](https://ohshitgit.com/)

# Tools
- [neovim](https://github.com/neovim/neovim) editor
- Terminal recorded with [asciinema](https://github.com/asciinema/asciinema)
- Player using [asciinema-player](https://github.com/asciinema/asciinema-player)
- Git interface [tig](https://github.com/jonas/tig)
