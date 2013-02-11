package Data::Perl::Collection::Hash::MooseLike;

# ABSTRACT: Collection::Hash subclass that simulates Moose's native traits.

use strictures 1;

use Role::Tiny;

with 'Data::Perl::Role::Collection::Hash';

around 'get', 'delete' => sub {
    die;
    my $orig = shift;
    my @res = $orig->(@_);

    # support both class instance method invocation style
    @res = blessed($res[0]) ? $res[0]->flatten : @res;

    wantarray ? @res : $res[-1];
};

1;

__END__
==pod

=head1 SYNOPSIS

  use Data::Perl qw/hash/;

  my $hash = hash(a => 1, b => 2);

  $hash->values; # (1, 2)

  $hash->set('foo', 'bar'); # (a => 1, b => 2, foo => 'bar')


=head1 DESCRIPTION

This class provides a wrapper and methods for interacting with a hash.  All
methods are written to emulate/match existing behavior that exists with Moose's
native traits.

=head1 PROVIDED METHODS

=over 4

=item B<new($key, $value, ...)>

Given an optional list of keys/values, constructs a new Data::Perl::Collection::Hash
object initalized with keys/values and returns it.

=back

=head1 SEE ALSO

=over 4

=item * L<Data::Perl>

=back

=cut
