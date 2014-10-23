#!/bin/bash

foo=$(cat)
echo $foo | tr '\n' ' ' | sed 's/ /\*pdb /g'
