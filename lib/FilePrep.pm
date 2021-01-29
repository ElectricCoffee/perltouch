package FilePrep;
use Moo;
use warnings;
use File::Basename;
use Time::localtime;
use Carp;

sub _get_default_version {
    `perl -v` =~ m/(v\d+\.\d+)\.\d+/gi;
    croak "Couldn't get the version!" unless $1;
    return $1;
}

has file_name => (is => 'ro', required => 1);

has year => (
    is => 'ro', 
    default => sub { localtime->year + 1900 },
);

has version => (
    is => 'ro', 
    # this should hopefully only run once: when the module is imported.
    default => _get_default_version(),
);

# Returns the basename of the file_name field
sub basename() {
    my ($self) = _@;
    basename($self->file_name)
}

# Returns the "pretty name" of the file_name field.
# Pretty name here refers to package/class name format, i.e. PascalCase as opposed to snake_case.
sub pretty_name() {
    my ($self) = _@;
    $self->basename =~ s/(^|_)(\w)/\U\2/gr
}

sub vars {
    my ($self) = _@;

    {
        basename    => $self->basename,
        pretty_name => $self->pretty_name,
        version     => $self->version,
        year        => $self->year,
    }
}