use Test::More;
use Data::Perl::Collection::Hash;

use Scalar::Util qw/refaddr/;

# thanks to Mojo::Collection for skeleton test
is ref(hash('a',1,'b',2)), 'Data::Perl::Collection::Hash', 'constructor shortcut works';

# hash
is hash('a', 1, 'b', 2)->{'b'}, 2, 'right result';
is_deeply {%{hash(a => 1, b => 2)}}, { a=>1, b=>2 }, 'right result';
# set
my $h = hash(a=>1);
$h->set(d=>5,e=>6);
is_deeply $h, {a=>1,d=>5,e=>6}, 'set many right result';

$h = hash(b=>3);
$h->set(d=>5);
is_deeply $h, {d=>5,b=>3}, 'set right result';

# get
is hash(a => 1, b => 2)->get('b'), 2, 'get right result';
is_deeply [hash(a => 1, b => 2)->get(qw/a b c/)], [1, 2, undef ], 'get many right result';

# delete
$h->delete(qw/b/);
is_deeply $h, {d=>5}, 'set right result';

$h->delete(qw/d/);
is_deeply $h, {}, 'set right result';

# keys
$h = hash(a=>1,b=>2,c=>3);
is_deeply [sort $h->keys], [qw/a b c/], 'keys works';

# exists
ok $h->exists('a'), 'exists ok';
ok !$h->exists('r'), 'exists fails ok';
$h->set('a'=>undef);
ok $h->exists('a'), 'exists on undef ok';

# defined
$h = hash(a=>1);
ok $h->defined('a'), 'defined ok';
ok !$h->defined('x'), 'defined not ok on undef';

# values
$h = hash(a=>1,b=>2);
is_deeply [sort $h->values], [1,2], 'values ok';

# kv
is_deeply [$h->kv], [ [qw/a 1/], [qw/b 2/]], 'kv works';

# elements
is_deeply [$h->elements], [ qw/a 1 b 2/], 'elements works';

#  clear
$h = hash(a=>1,b=>2);
my $old_addr = refaddr($h);
$h->clear;
is_deeply {%{$h}}, {}, 'clear works';
is refaddr($h), $old_addr, 'refaddr matches on clear';

# count/is_empty
is $h->count, 0, 'empty count works';
is $h->is_empty, 1, 'is empty works';
$h = hash(a=>1,b=>2);
is $h->count, 2, 'count works';
is $h->is_empty, 0, 'is empty works';

# accessor
$h = hash(a=>1,b=>2);
is $h->accessor('a'), 1, 'accessor get works';
is $h->accessor('a', '4'), 4, 'accessor set works';

is $h->accessor('r'), undef, 'accessor get on undef works';
is $h->accessor('r', '5'), 5, 'accessor set on undef works';

# shallow_clone
$h = hash(a=>1,b=>2);
my $foo = $h->shallow_clone;
is_deeply [$h->kv], [ [qw/a 1/], [qw/b 2/]], 'shallow clone is a clone';
isnt refaddr($h), refaddr($foo), 'refaddr doesnt match on clone';

done_testing();
