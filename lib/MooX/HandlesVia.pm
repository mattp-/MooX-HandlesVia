package MooX::HandlesVia;

use strictures 1;
use Module::Runtime qw/require_module/;

sub import {
  my ($class) = @_;

  no strict 'refs';
  no warnings 'redefine';

  my $target = caller;
  if(my $has = $target->can('has')) {
    *{$target.'::has'} = sub {
      process_has(@_);
      $has->(@_);
    }
  }
}

sub process_has {
  my $name = shift;
  my %opts = @_;
  my $handles = $opts{handles} || return;

  if (my $via = $opts{handles_via}) {
    # try to load
    require_module($via);

    # we need to switch up handles refs that match @symbols
    while (my ($target, $method) = each %$handles) {
      if ($via->can($method)) {
        $handles->{$target} = '${\\'.$via.'->can("'.$method.'")}';
      }
    }
  }
}

1;
