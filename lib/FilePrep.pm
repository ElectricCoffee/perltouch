package FilePrep;
use Moo;
use warnings;
use File::Basename ();
use Time::localtime;
use Carp;

sub _get_default_version {
    `perl -v` =~ m/(v\d+\.\d+)\.\d+/gi;
    croak "Couldn't get the version!" unless $1;
    return $1;
}

has file_name => (is => 'ro', required => 1);
has file_ext  => (is => 'ro', default  => sub {'.pl'});

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
sub basename {
    my ($self) = @_;
    return File::Basename::basename($self->file_name);
}

# if the file already has an extension, assume it's what the user wanted and leave it alone.
# otherwise append the new extension.
sub out_path {
    my ($self, $force_ext) = @_;
    
    if (!$force_ext && $self->file_name =~ m/\.\w+$/) {
        return $self->file_name;
    } else {
        return $self->file_name . $self->file_ext;
    }
}

# Returns the "pretty name" of the file_name field.
# Pretty name here refers to package/class name format, i.e. PascalCase as opposed to snake_case.
sub pretty_name() {
    my ($self) = @_;
    $self->basename =~ s/(^|_)(\w)/\U$2/gr
}

sub vars {
    my ($self) = @_;

    return {
        basename    => $self->basename,
        pretty_name => $self->pretty_name,
        version     => $self->version,
        year        => $self->year,
    };
}


1;
__END__
=head1 File Prep
A class for preparing the file name to become the variables used as input for the templating engine.
=over 4
=item B<new (file_name =E<gt> FILE_NAME, file_ext =E<gt> FILE_EXT, version =E<gt> VERSION, year =E<gt> YEAR)>
Creates a new instance of the FilePrep class.
=over 4
=item B<file_name>
The file name of the file that is going to be generated.
=item B<file_ext> (optional)
The extension of the file to be generated.
Leaving it out will default it to '.pl'.
=item B<version> (optional)
The Perl version you wish to target.
Leaving it out will cause FilePrep to target the version currently installed.
=item B<year> (optional)
The copyright year.
Leaving it out will default to the current year.
=back
=item B<basename()>
Returns the basename of the supplied file name.
=item B<out_path(FORCE_EXT)>
Generates an out path based on the file name and the file extension.
If the file name already has an extension, it will not supply one unless FORCE_EXT is true.
=item B<pretty_name()>
Creates a "pretty" CamelCased name.
=item B<vars()>
Generates the output hash ref expected by the templating engine.
=back
=cut