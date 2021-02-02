#!/usr/bin/env/perl

use v5.28;
use warnings;
use lib './lib';
use Getopt::Long;
use Template;
use Time::localtime;
use autodie;

use Util;
use FilePrep;

GetOptions (
    'class=s{,}'            => \my @classes,
    'file=s{,}'             => \my @files,
    'package|module=s{,}'   => \my @modules,
    'script=s{,}'           => \my @scripts,
    force_ext               => \my $force_ext,
    stdout                  => \my $want_stdout,
);

# if no type was explicitly used, default to "file".
@files = @ARGV unless @classes || @files || @modules || @scripts;

my $template = Template->new({
    INCLUDE_PATH => './templates'
});

# TODO: find a better place for this sub.
sub render {
    my ($temp_f, $temp_ext, @files) = @_;

    for my $file (@files) {
        # if the file doesn't already exist or the user wishes to overwrite it
        if (! -e $file || Util::prompt("The file $file already exists. Overwrite it?")) {
            my $prepped = FilePrep->new(file_name => $file, file_ext => $temp_ext);
            my $path = $prepped->out_path($force_ext);

            if ($want_stdout) {
                $template->process($temp_f, $prepped->vars);
            } else {
                say "Writing $path...";
                $template->process($temp_f, $prepped->vars, $path, { binmode => ':raw' })
                    or warn "Could not write $path!";
            }
        } else {
            say "Skipping $file...";
        }
    }
}

render 'class.pm.tt'  , '.pm', @classes;
render 'file.pl.tt'   , '.pl', @files;
render 'modules.pl.tt', '.pm', @modules;
render 'file.pl.tt'   , ''   , @scripts;

__END__
=head1 perltouch
perltouch is a tool for generating Perl source files.
In its most basic form, it'll create a new source file with all my usual imports already defined for my convenience.

Things like C<autodie>, and C<Getopt::Long> are imported by default as well as setting the version number to the one currently installed on the machine.

For packages and classes, package specific things will be imported by default, such as C<Carp> for in-package error propagation.

The main difference between a I<file> and a I<script> is the file extension.
A perl file will end in C<.pl> while a perl script won't have any extension at all, but otherwise be identical.