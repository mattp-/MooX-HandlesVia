package Data::Perl::Bool::MooseLike;

# ABSTRACT: data::Perl::Bool subclass that simulates Moose's native traits.

use strictures 1;

use Role::Tiny::With;
use Class::Method::Modifiers;

with 'Data::Perl::Role::Bool';

my @methods = grep { $_ ne 'new' } Role::Tiny->methods_provided_by('Data::Perl::Role::Bool');

around @methods => sub {
    my $orig = shift;

    $orig->(\$_[0], @_[1..$#_]);
};

1;

__END__
==pod

=head1 SYNOPSIS

    # you should not be consuming this class directly.

=head1 DESCRIPTION

This class provides a wrapper and methods for interacting with a boolean. All
methods are written to emulate/match existing behavior that exists with Moose's
native traits.

=head1 SEE ALSO

=over 4

=item * L<Data::Perl>

=item * L<Data::Perl::Role::Collection::Bool>

=back

=cut
