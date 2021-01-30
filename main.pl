#!/usr/bin/env/perl

use v5.28;
use warnings;
use lib './lib';
use Getopt::Long;
use Template;
use Time::localtime;
use autodie;

use Util;

use constant {
    CLASS_T     => 'class',
    FILE_T      => 'file',
    MODULE_T    => 'module',
    SCRIPT_T    => 'script',
}

my %template_and_extensions = (
    &CLASS_T    => ['class.pm.tt', '.pm'],
    &FILE_T     => ['file.pl.tt', '.pl'],
    &MODULE_T   => ['module.pm.tt', '.pm'],
    &SCRIPT_T   => ['file.pl.tt', ''],
)

my $template_type;

GetOptions (
    class               => sub { $template_type = CLASS_T  },
    file                => sub { $template_type = FILE_T   },
    'package|module'    => sub { $template_type = MODULE_T },
    script              => sub { $template_type = SCRIPT_T },
    force_ext           => \my $force_ext,
);

$template_type ||= FILE_T;

my $template = Template->new({
    INCLUDE_PATH => './templates'
});

my ($temp_f, $temp_ext) = $template_and_extensions{$template_type}->@*;

for my $file (@ARGV) {
    # if the file doesn't already exist or the user wishes to overwrite it
    if (! -e $file || Util::prompt("The file $file already exists. Overwrite it?")) {
        my $prepped = FilePrep->new(file_name => $file, file_ext => $temp_ext);
        my $path = $prepped->out_path($force_ext);

        say "Writing $path..."
        $template->process($temp_f, $prepped->vars, $path) 
            or warn "Could not write $path!";
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