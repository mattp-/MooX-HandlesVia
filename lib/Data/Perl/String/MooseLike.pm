package Data::Perl::String::MooseLike;

# ABSTRACT: data::Perl::String subclass that simulates Moose's native traits.

use strictures 1;

use Role::Tiny::With;
use Class::Method::Modifiers;

with 'Data::Perl::Role::String';

my @methods = grep { $_ ne 'new' } Role::Tiny->methods_provided_by('Data::Perl::Role::String');

around @methods => sub {
    my $orig = shift;

    $orig->(\$_[0], @_[1..$#_]);
};

1;

__END__
==pod

=head1 SYNOPSIS

  use Data::Perl::Collection::Hash::MooseLike;

  my $hash = Data::Perl::Collection::Hash::MooseLike->new(a => 1, b => 2);

  $hash->values; # (1, 2)

  $hash->set('foo', 'bar'); # (a => 1, b => 2, foo => 'bar')


=head1 DESCRIPTION

This class provides a wrapper and methods for interacting with a hash.  All
methods are written to emulate/match existing behavior that exists with Moose's
native traits.

=head1 DIFFERENCES IN FUNCTIONALITY

=over 4

=item B<get($key, $key, ...)>

Returns values from the hash.

In list context it returns a list of values in the hash for the given keys. In
scalar context it returns the value for the last key specified.

=item B<set($key, $value, ...)>

Sets the elements in the hash to the given values. It returns the new values
set for each key, in the same order as the keys passed to the method.

This method requires at least two arguments, and expects an even number of
arguments.

=item B<delete($key, $key, ...)>

Removes the elements with the given keys.

In list context it returns a list of values in the hash for the deleted keys.
In scalar context it returns the value for the last key specified.

=back

=head1 SEE ALSO

=over 4

=item * L<Data::Perl>

=item * L<Data::Perl::Role::Collection::String>

=back

=cut
