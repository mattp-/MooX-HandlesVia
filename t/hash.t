use strict;
use warnings;
use Data::Perl::Collection::Hash;
{
  package Ex1;

  use Moo;

  has foos => (
    is => 'ro',
    handles => {
      'get_foo' => 'get',
      'set_foo' => 'set',
    },
  );

  has bars => (
    is => 'ro',
    handles => {
      'get_bar' => '${\Data::Perl::Collection::Hash->can("get")}',
      'set_bar' => '${\Data::Perl::Collection::Hash->can("set")}',
    },
  );
}

my $ex = Ex1->new(
  foos => Data::Perl::Collection::Hash->new(one => 1),
  bars => { one => 1 },
);

use Test::More;

is ($ex->get_foo('one'), 1, 'get_foo worked');
is ($ex->get_bar('one'), 1, 'get_bar worked');

$ex->set_foo('two', 2, 'set_foo worked');
$ex->set_bar('two', 2, 'set_bar worked');

is ($ex->foos->{'two'}, 2, 'foos accessor worked');

done_testing;
