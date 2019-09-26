#+TITLE: Jane Street OCaml Workshop

This repo contains exercises and build instructions to help you get started
developing in OCaml.

* Installing build tools and libraries
  See [[https://github.com/janestreet/install-ocaml/blob/master/README.org][README.org in install-ocaml]] for instructions.
* Exercises
  The [[file:02-exercises][exercises]] directory contains a number of exercises to get you started with
  OCaml. Each one has some expect-tests embedded in it. The workflow is:

  #+BEGIN_SRC bash
  cd 02-exercises/$problem_dir

  dune runtest # builds and runs inline tests
  # Look at test output and compiler errors, edit problem.ml, rerun:
  dune runtest
  #+END_SRC
* Snake, Lumines, and Frogger
  Once you're done with the exercises, you can also implement simplified clones
  of the following arcade games:

  - [[file:03-snake/README.org][snake]] (runs on your computer)
  - [[file:03-lumines/README.org][lumines]] (runs on your computer)
  - [[file:03-frogger/README.org][frogger]] (runs in a web browser)
 
* ~Async~
  The OCaml standard library has various low-level calls for working with
  sockets in the ~Unix~ module and Jane Street's ~Core~ library wraps all of
  those. But, if you want your program to be able to wait for multiple events at the
  same time, you likely want to be able to program /concurrently/.

  One library for writing code in this style is [[https://opensource.janestreet.com/async/][Async]]. [[https://ocaml.janestreet.com/ocaml-core/latest/doc/async/index.html][Async]] provides ~Reader~
  and ~Writer~ abstractions for I/O which, paired with the [[https://ocaml.janestreet.com/ocaml-core/latest/doc/async_extra/Async_extra/Tcp/][Tcp]] module should
  have most of what you need for either of the projects below.

  Before proceeding, it would probably be a good idea to read [[https://dev.realworldocaml.org/18-concurrent-programming.html][Chapter 18]] of
  /Real World OCaml/. There is some example code in the next section which
  should set you on your way.
* Bigger projects
  Once you've made it to this point, there are a few possible paths laid out for you:

  - You can work on writing a bot for a chat protocol called IRC. See the
    [[file:04-bigger-projects/irc-bot/README.org][irc-bot README]] to get started!
  - You can work on writing your very own version of [[https://github.com/junegunn/fzf][fzf]] in OCaml. See the
    [[file:04-bigger-projects/fuzzy-finder/README.org][fuzzy-finder README]] to get started!
  - Or, if you want, you can continue making improvements and extensions to your
    version of Frogger (see the [[file:03-frogger][frogger README]] for some ideas).

* Documentation and resources
** OCaml
   - [[https://dev.realworldocaml.org/toc.html][Real World OCaml]]
   - [[http://caml.inria.fr/pub/docs/manual-ocaml/][OCaml manual]]
** Jane Street libraries and tools
   - [[https://opensource.janestreet.com/][An overview of Jane Street's open source things]]
   - [[https://ocaml.janestreet.com/ocaml-core/v0.10/doc/][Documentation for Core]]
** dune
   - [[https://www.youtube.com/watch?v=BNZhmMAJarw][Video tutorial]]
   - [[https://dune.readthedocs.io/en/latest/][Manual]]

