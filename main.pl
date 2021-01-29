#!/usr/bin/env/perl

use v5.28;
use warnings;
use lib './lib';
use Getopt::Long;
use Template;
use Time::localtime;
use autodie;

use Util;

GetOptions (
    'package|module'    => \my $is_module,
    class               => \my $is_class,
    file                => \my $is_file,
    script              => \my $is_script,
);

# assume you want a file if nothing else has been chosen.
$is_file = 1 
    unless $is_class || $is_module || $is_script;

my $template = Template->new({
    INCLUDE_PATH => './templates'
});

# TODO: refactor this into something more elegant.
my $template_file = $is_file || $is_script  ? 'file.pl.tt'
                  : $is_module              ? 'module.pm.tt'
                  : $is_class               ? 'class.pm.tt'
                  : die 'Could not determine file type.'; # shouldn't be possible.

my $extension = $is_file                ? '.pl'
              : $is_script              ? ''
              : $is_module || $is_class || '.pm'

for my $file (@ARGV) {
    # if the file doesn't already exist or the user wishes to overwrite it
    if (! -e $file || Util::prompt("The file $file already exists. Overwrite it?")) {
        my $prepped = FilePrep->new(file_name => $file);

        $template->process($template_file, $prepped->vars, $prepped->basename);
    }
}

__END__
=head1 perltouch
perltouch is a tool for generating Perl source files.
In its most basic form, it'll create a new source file with all my usual imports already defined for my convenience.

Things like C<autodie>, and C<Getopt::Long> are imported by default as well as setting the version number to the one currently installed on the machine.

For packages and classes, package specific things will be imported by default, such as C<Carp> for in-package error propagation.

The main difference between a I<file> and a I<script> is the file extension.
A perl file will end in C<.pl> while a perl script won't have any extension at all, but otherwise be identical.