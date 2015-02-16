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

  use Data::Perl::Collection::String::MooseLike;

  my $string = Data::Perl::Collection::String::MooseLike->new("this is a string\n");

  $string->chomp;

  $string->substr(); # etc



=head1 DESCRIPTION

This class provides a wrapper and methods for interacting with a string. All
methods are written to emulate/match existing behavior that exists with Moose's
native traits. You should probably be looking at Data::Perl's documentation instead.

=head1 SEE ALSO

=over 4

=item * L<Data::Perl>

=item * L<Data::Perl::Role::Collection::String>

=back

=cut
