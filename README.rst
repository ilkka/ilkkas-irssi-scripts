================
My Irssi scripts
================

:author: Ilkka Laukkanen <ilkka.s.laukkanen@gmail.com>
:license: GPLv2

urlcheck
========

This script automagically checks URLs against given keywords. Matched
keywords are printed next to the URL to help you guess at the URL contents.
There is also a regex blacklist, see the output of "/set urlcheck".

This script requires URI::Find and URI::Find::Rule.

Both the keyword and blacklist items are separated by single commas.

To use, simply copy urlcheck.pl to your ~/.irssi/scripts and
/script load urlcheck.

urltitles
=========

This script fetches URL contents using LWP and outputs their titles.

