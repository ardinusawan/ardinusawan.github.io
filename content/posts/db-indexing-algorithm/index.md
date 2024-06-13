---
author: ["I Dewa Putu Ardi Nusawan"]
title: "Correctly choose indexing algorithm"
date: 2024-06-13
description: "Correctly choose indexing algorithm of your database"
tags: ["database", "postgresql"]
thumbnail:
  image: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FPostgreSQL&psig=AOvVaw1XND2fGqoYubtq0MyfwWaz&ust=1718375993626000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJiAt8jn2IYDFQAAAAAdAAAAABAJ"
cover:
  image: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fmedium.com%2Fcodex%2Fintro-to-postgresql-c8da31335c34&psig=AOvVaw1XND2fGqoYubtq0MyfwWaz&ust=1718375993626000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJiAt8jn2IYDFQAAAAAdAAAAABAR"
  alt: "postgresql"
  caption: "postgresql"
  relative: true
ShowToc: true
comments: true
draft: true
---

# Why we should care what the algo being used?

No, you should not. Unless you have million - or more then you SHOULD. It boils down to performance.

## B-Tree

I bet most of you think that is acronym of binary 🌳. Actualy, it balance tree. This is default algorithm when creating the index, and usually we don't think twice when using it.

## Inspired by

- [Jangan Pake UUID di Database? | PZN Reaction](https://www.youtube.com/watch?v=j4_BxmmLz3s)
