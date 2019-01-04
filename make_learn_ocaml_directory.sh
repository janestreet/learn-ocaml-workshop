#!/bin/bash

mkdir ../learn-ocaml
cp Makefile ../learn-ocaml/

dune clean
cp -r 02-exercises/ ../learn-ocaml/01-exercises
cp -r 03-lumines/ ../learn-ocaml/02-lumines

dune build solutions/lumines/bin/lumines.exe
cp _build/default/solutions/lumines/bin/lumines.exe ../learn-ocaml/lumines_demo.exe
