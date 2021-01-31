use v5.28;
use warnings;
use Test::More;

use lib './lib';

require_ok('FilePrep');

# basic features
my $path = 'some/path/to/long_example_name';
my $prep = FilePrep->new(file_name => $path);

is($prep->basename, 'long_example_name', 'test basename');
is($prep->pretty_name, 'LongExampleName', 'test pretty_name');
is($prep->out_path, "$path.pl", 'test out_path');
is($prep->year, 2021, 'test automatic year');
is($prep->version, 'v5.28', 'test automatic version');

# slightly more advanced features
$path = 'some/other/path/to/file_name.tt';
$prep = FilePrep->new(file_name => $path, file_ext => '.pm');

is($prep->basename, 'file_name.tt', 'test existing extension');
is($prep->out_path, $path, 'test out_path with existing extension');
is($prep->out_path(1), "$path.pm", 'test out_path with forced extension');

done_testing();