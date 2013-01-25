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
      $has->(process_has_args(@_));
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

    while (my ($target, $method) = each %$handles) {
      if ($via->can($method)) {
        $handles->{$target} = '${\\'.$via.'->can("'.$method.'")}';
      }
    }
  }

  %opts;
}

1;
