#! /usr/bin/env python
import sys
import os
import commands
import argparse

authors = [
"Amy Keating",
"Andreas Pluckthun",
"Andrew Leaver-Fay",
"Balaji Rao",
"Brian Kuhlman",
"Bryan Der",
#"Dek Woolfson", Apparently Dek isn't his actual name
#"David Baker", To many david bakers....
"Frank DiMaio",
"George Church",
"Gurkan Guntas",
"Hayretin Yumerefendi",
"Jane S Richardson",
"Jeffrey Gray",
"Jens Meiler",
"John Karanicolas",
"Joseph Harrison",
"Julia Shifman",
"Matthew O'Meara",
"Mike Tyka",
"Michael Levitt",
"Oana Lungu",
"Ora Schueler-Furman",
"Oliver F Lange",
"P Benjamin Stranges",
"Phil Bradley",
"Phillip Bradley",
"Roland Dunbrack",
"Rhiju Das",
"Ryan Hallett",
"Steven Lewis",
"Tanja Kortemme",
"Wendell Lim",
"Will Sheffler",
"William Degrado",
]

search = ""
for author in authors:
	search = search + author + "[Author - Full] OR "
search = search[:-4]
print search

