package FilePrep;
use Moo;
use warnings;
use File::Basename;

has file_name => (is => 'ro', required => 1);
has basename => (is => 'lazy');
has pretty_name => (is => 'lazy');

sub _build_basename {
    my ($self) = _@;
}

sub _build_pretty_name {
    my ($self) = _@;
}

sub make_template_hash {
    my ($self) = _@;
}