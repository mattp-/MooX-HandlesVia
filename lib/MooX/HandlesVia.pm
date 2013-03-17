package MooX::HandlesVia;
# ABSTRACT: NativeTrait-like behavior for Moo.

use strictures 1;
use Module::Runtime qw/require_module/;

# reserved hardcoded mappings for classname shortcuts.
my %RESERVED = (
  'Array' => 'Data::Perl::Collection::Array::MooseLike',
  'Hash' => 'Data::Perl::Collection::Hash::MooseLike',
  'String' => 'Data::Perl::String::MooseLike',
  'Bool' => 'Data::Perl::Bool::MooseLike',
  'Number' => 'Data::Perl::Number::MooseLike',
  'Code' => 'Data::Perl::Code',
);

sub import {
  my ($class) = @_;

  no strict 'refs';
  no warnings 'redefine';

  my $target = caller;
  if(my $has = $target->can('has')) {
    *{$target.'::has'} = sub {
      $has->(process_has(@_));
    }
  }
}

sub process_has {
  my ($name, %opts) = @_;
  my $handles = $opts{handles};
  return ($name, %opts) if not $handles or ref $handles ne 'HASH';

  if (my $via = delete $opts{handles_via}) {
    # try to load the reserved mapping, if it exists, else the full name
    $via = $RESERVED{$via} || $via;

    require_module($via);

    while (my ($target, $delegation) = each %$handles) {
      # if passed an array, handle the curry
      if (ref $delegation eq 'ARRAY') {
        my ($method, @curry) = @$delegation;
        if ($via->can($method)) {
          $handles->{$target} = ['${\\'.$via.'->can("'.$method.'")}', @curry];
        }
      }
      elsif (ref $delegation eq '') {
        if ($via->can($delegation)) {
          $handles->{$target} = '${\\'.$via.'->can("'.$delegation.'")}';
        }
      }
    }
  }

  ($name, %opts);
}

1;

__END__
==pod

=head1 SYNOPSIS

  {
    package Hashy;
    use Moo;
    use MooX::HandleVia;

    has hash => (
      is => 'rw',
      handles_via => 'Hash',
      handles => {
        get_val => 'get',
        set_val => 'set',
        all_keys => 'keys'
      }
    );
  }

  my $h = Hashy->new(hash => { a => 1, b => 2});

  $h->get('b'); # 2

  $h->set('a', 'BAR'); # sets a to BAR

  my @keys = $h->all_keys; # returns a, b

=head1 DESCRIPTION

MooX::HandlesVia is an extension of Moo's 'handles' attribute functionality. It
provides a means of proxying functionality from an external class to the given
atttribute. This is most commonly used as a way to emulate 'Native Trait'
behavior that has become commonplace in Moose code, for which there was no Moo
alternative.

=head1 SHORTCOMINGS

Due to current Moo implementation details there are some deficiencies in how
MooX::HandlesVia in comparison to what you would expect from Moose native
traits.

=over 4

=item * methods delegated via the Moo 'handles' interface are passed the
attribue value directly. and there is no way to access the parent class. This
means if an attribute is updated any triggers or type coercions B<WILL NOT>
fire.

=item * Moo attribute method delegations are passed the attribute value. This
is fine for references (objects, arrays, hashrefs..) it means simple scalar
types are B<READ ONLY>. This unfortunately means Number, String, Counter, Bool
cannot modify the attributes value, rendering them largely useless.

=back

=head1 PROVIDED INTERFACE/FUNCTIONS

=over 4

=item B<process_has(@_)>

MooX::HandlesVia preprocesses arguments passed to has() attribute declarations
via the process_has function. In a given Moo class, If 'handles_via' is set to
a ClassName string, and 'handles' is set with a hashref mapping of desired moo
class methods that should map to ClassName methods, process_has() will create
the appropriate binding to create the mapping IF ClassName provides that named
method.

  has options => (
    is => 'rw',
    handles_via => 'Array',
    handles => {
      mixup => 'shuffle',
      unique_options => 'uniq',
      all_options => 'elements'
    }
  );

=back

The following handles_via keywords are reserved as shorthand for mapping to
L<Data::Perl>:

=over 4

=item * B<Hash> maps to L<Data::Perl::Collection::Hash::MooseLike>

=item * B<Array> maps to L<Data::Perl::Collection::Array::MooseLike>

=item * B<String> maps to L<Data::Perl::String::MooseLike>

=item * B<Number> maps to L<Data::Perl::Number::MooseLike>

=item * B<Bool> maps to L<Data::Perl::Bool::MooseLike>

=item * B<Code> maps to L<Data::Perl::Code>

=back

=head1 SEE ALSO

=over 4

=item * L<Moo>

=item * L<MooX::late>

=back

=cut
