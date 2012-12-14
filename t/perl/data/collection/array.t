use Test::More;
use Data::Perl::Collection::Array;
use Scalar::Util qw/refaddr/;

# thanks to Mojo::Collection for skeleton test

# size
$collection = array();
is $collection->count, 0, 'right size';
$collection = array(undef);
is @{$collection}, 1, 'right size';
$collection = array(23);
is $collection->count, 1, 'right size';
$collection = array([2, 3]);
is $collection->count, 1, 'right size';
$collection = array(5, 4, 3, 2, 1);
is @{$collection}, 5, 'right size';


# Array
is array(1,2,3)->[1], 2, 'right result';
is_deeply [@{array(3, 2, 1)}], [3, 2, 1], 'right result';
my $collection = array(1, 2);
push @$collection, 3, 4, 5;
is_deeply [@$collection], [1, 2, 3, 4, 5], 'right result';

=begin
# each
$collection = array(3, 2, 1);
is_deeply [$collection->each], [3, 2, 1], 'right elements';
$collection = array([3], [2], [1]);
my @results;
$collection->each(sub { push @results, $_->[0] });
is_deeply \@results, [3, 2, 1], 'right elements';
@results = ();
$collection->each(sub { push @results, shift->[0], shift });
is_deeply \@results, [3, 1, 2, 2, 1, 3], 'right elements';
=cut

#count/is_empty
is array()->count, 0, 'count correct.';
is array(1,2,3)->count, 3, 'count correct.';
is array()->is_empty, 1, 'is_empty correct.';
is array(1,2,3)->is_empty, 0, 'is_empty correct.';

# elements
is_deeply [array()->elements], [], 'elements correct.';
is_deeply [array(1, 2, 3)->elements], [1,2,3], 'elements correct.';

# get
is array()->get(0), undef, 'get correct';
is array(1,2)->get(1), 2, 'get correct';

# accessor get
is array()->accessor(0), undef, 'accessor get correct';
is array(1,2)->accessor(1), 2, 'accessor get correct';

# pop
is array()->pop, undef, 'pop correct';
is array(1,2)->pop, 2, 'pop correct';

# push
my $ar = array(2); $ar->push(1);
is_deeply [$ar->elements], [2,1], 'push works';

# shift
my $ar = array(2,3);
is $ar->shift, 2, 'shift works';
is_deeply [$ar->elements], [3], 'shift works';

# unshift
my $ar = array(3);
$ar->unshift(2), 'unshift works';
is_deeply [$ar->elements], [2,3], 'unshift works';

# splice
my $ar = array(1);
$ar->splice(0,1,2);
is_deeply [$ar->elements], [2], 'splice works';

# first/first_index
$collection = array(5, 4, [3, 2], 1);
is_deeply $collection->first(sub { ref $_ eq 'ARRAY' }), [3, 2], 'right result';
is_deeply $collection->first_index(sub { ref $_ eq 'ARRAY' }), 2, 'right result';
is $collection->first(sub { $_ < 5 }), 4, 'right result';
is $collection->first_index(sub { $_ < 5 }), 1, 'right result';
is $collection->first(sub { ref $_ eq 'CODE' }), undef, 'no result';
is $collection->first_index(sub { ref $_ eq 'CODE' }), -1, 'no result';
$collection = array();
is $collection->first(sub { defined $_ }), undef, 'no result';
is $collection->first_index(sub { defined $_ }), -1, 'no result';
#is $collection->first, 5, 'right result';
#is $collection->first(qr/[1-4]/), 4, 'right result';
#is $collection->first, undef, 'no result';

# grep
$collection = array(1, 2, 3, 4, 5, 6, 7, 8, 9);
is_deeply [$collection->grep(sub {/[6-9]/})], [6, 7, 8, 9],
  'right elements';
is_deeply [$collection->grep(sub { $_ > 5 })], [6, 7, 8, 9],
  'right elements';
is_deeply [$collection->grep(sub { $_ < 5 })], [1, 2, 3, 4],
  'right elements';
is_deeply [$collection->grep(sub { $_ == 5 })], [5], 'right elements';
is_deeply [$collection->grep(sub { $_ < 1 })], [], 'no elements';
is_deeply [$collection->grep(sub { $_ > 9 })], [], 'no elements';

# map
$collection = array(1, 2, 3);
$collection->map(sub { $_ + 1 });
is_deeply [@$collection], [1, 2, 3], 'right elements';
$collection->map(sub { shift() + 2 });
is_deeply [@$collection], [1, 2, 3], 'right elements';

# reduce
$collection = array(1..5);
is $collection->reduce(sub { $_[0] + $_[1] }), 15, 'reduce works';

# sort
$collection = array(5,2,4,1,3);
is_deeply [$collection->sort(sub { $_[0] <=> $_[1] })], [1,2,3,4,5], 'sort works';

# sort_in_place
$collection = array(5,2,4,1,3);
$collection->sort_in_place(sub { $_[0] <=> $_[1] });
is_deeply [$collection->elements], [1,2,3,4,5], 'sort works';

# shuffle
$collection = array(0 .. 10);
my $random = [$collection->shuffle];
is $collection->count, scalar @$random, 'same number of elements';
isnt "@$collection", "@$random", 'different order';
is_deeply [array()->shuffle], [], 'no elements';

# sort
$collection = array(2, 5, 4, 1);
is_deeply [$collection->sort], [1, 2, 4, 5], 'right order';
is_deeply [$collection->sort(sub { $_[1] cmp $_[0] })], [5, 4, 2, 1],
  'right order';
$collection = array(qw(Test perl Mojo));
is_deeply [$collection->sort(sub { uc(shift) cmp uc(shift) })],
  [qw(Mojo perl Test)], 'right order';
$collection = array();
is_deeply [$collection->sort], [], 'no elements';
is_deeply [$collection->sort(sub { $_[1] cmp $_[0] })], [],
  'no elements';

# uniq
$collection = array(1, 2, 3, 2, 3, 4, 5, 4);
is_deeply [$collection->uniq], [1, 2, 3, 4, 5], 'right result';
#is_deeply [$collection->uniq->reverse->uniq ], [5, 4, 3, 2, 1], 'right result';

# join
$collection = array(1, 2, 3);
is $collection->join(''),    '123',       'right result';
is $collection->join('---'), '1---2---3', 'right result';
is $collection->join("\n"),  "1\n2\n3",   'right result';
#$collection = array(array(1, 2, 3), array(3, 2, 1));
#is $collection->join(''), "1\n2\n33\n2\n1", 'right result';
#is $collection->join('/')->url_escape, '1%2F2%2F3', 'right result';

# set
$ar = array(1,2,3);
$ar->set(0, 2);
is_deeply $ar, [2,2,3], 'set works';
$ar->set(5, 4);
is_deeply $ar, [2,2,3,undef,undef,4], 'set works';

# accessor set
$ar = array(1,2,3);
$ar->accessor(0, 2);
is_deeply $ar, [2,2,3], 'set works';
$ar->set(5, 4);
is_deeply $ar, [2,2,3,undef,undef,4], 'set works';


# delete
$ar = array(1,2,3);
$ar->delete(1);
is_deeply [$ar->elements], [1,3], 'delete works';

# insert
$ar = array(1,2,3);
$ar->insert(1, 5);
is_deeply [$ar->elements], [1,5,2,3], 'insert works';

# natatime
$ar = array(1,2,3,4,5,6,7,8,9,10,11);
my $it = $ar->natatime(5);
is_deeply [$it->()], [1,2,3,4,5], 'iterator returns correct';
is_deeply [$it->()], [6,7,8,9,10], 'iterator returns correct';
is_deeply [$it->()], [11], 'iterator returns correct';

$ar->natatime(11, sub { is_deeply([@_], [1..11], 'passing coderef works for natatime iterator')});

# shallow_clone
$ar = array(1,2,3);
my $foo = $ar->shallow_clone;
is_deeply([$ar->elements], $foo, 'shallow clone is a clone');

isnt refaddr($ar), refaddr($foo), 'refaddr doesnt match on clone';

=begin
# slice
$collection = array(1, 2, 3, 4, 5, 6, 7, 10, 9, 8);
is_deeply [$collection->slice(0)],  [1], 'right result';
is_deeply [$collection->slice(1)],  [2], 'right result';
is_deeply [$collection->slice(2)],  [3], 'right result';
is_deeply [$collection->slice(-1)], [8], 'right result';
is_deeply [$collection->slice(-3, -5)], [10, 6], 'right result';
is_deeply [$collection->slice(1, 2, 3)], [2, 3, 4], 'right result';
is_deeply [$collection->slice(6, 1, 4)], [7, 2, 5], 'right result';
is_deeply [$collection->slice(6 .. 9)], [7, 10, 9, 8], 'right result';

# pluck
$collection = array(array(1, 2, 3), array(4, 5, 6), array(7, 8, 9));
is $collection->pluck('reverse'), "3\n2\n1\n6\n5\n4\n9\n8\n7", 'right result';
is $collection->pluck(join => '-'), "1-2-3\n4-5-6\n7-8-9", 'right result';
=cut

done_testing();
