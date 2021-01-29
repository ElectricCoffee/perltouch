# perltouch

Perltouch is the second iteration a CLI tool I created for myself a while back.

Its purpose is simply to simplify the creation of Perl scripts for everyday use.

The most basic use is simply writing `perltouch filename` where it'll make a `filename.pl` file and populate it with the required boilerplate code.

That's where my original script ended.

This new version also has the ability to create class and package files by simply supplying the appropriate flags in the too. `perltouch --class filename` would create a `filename.pm` which automatically imports `Moo`.

## Dependencies

- Moo
- Template
