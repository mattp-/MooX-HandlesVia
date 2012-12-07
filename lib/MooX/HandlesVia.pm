package MooX::HandlesVia;

use strictures 1;
use Module::Runtime qw/require_module/;
use Package::Stash;
use Syntax::Keyword::Junction qw/any/;

sub import {
  my ($class) = @_;

  no strict 'refs';
  no warnings 'redefine';

  my $target = caller;
  my $has = $target->can('has');

  *{$target.'::has'} = sub {
    _process_has(@_);
    $has->(@_);
  }
}

sub _process_has {
  my $name = shift;
  my %opts = @_;
  my $handles = $opts{handles} || return;

  if (my $via = $opts{handles_via}) {
    # try to load
    require_module($via);

    # we were successful, get a list of provided methods
    my @symbols = Package::Stash->new($via)->list_all_symbols('CODE');

    # we need to switch up handles refs that match @symbols
    while (my ($target, $method) = each %$handles) {
      if (any(@symbols) eq $method) {
        my $g = '${\\'.$via.'->can("'.$method.'")}';
        $handles->{$target} = '${\\'.$via.'->can("'.$method.'")}';
      }
    }
  }
}

1;
