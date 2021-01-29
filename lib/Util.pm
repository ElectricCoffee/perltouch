package Util;

use v5.28;
use warnings;
no warnings 'experimental::smartmatch';

sub prompt {
    my ($line) = @_;
    while () {
        say "$line (Y/n)";
        chomp(my $input = <STDIN>);
        
        given ($input) {
            when (m/y|yes|yup|aye|indeed/i) {
                return 1;
            }

            when (m/n|no|nope|nu-uh|nah/i) {
                return '';
            }

            default {
                next;
            }
        }
    }
}

1;