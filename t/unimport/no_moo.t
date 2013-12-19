# cleaning the namespace using "no Moo"
use strict;
use warnings;

use Test::More;

{
    package NoMoo::Moo;
    use Moo;
    no Moo;
}

{
    package NoMoo::HandlesVia;
    use Moo;
    use MooX::HandlesVia;
    no Moo;
}


my $moo_obj = new_ok "NoMoo::Moo";
my $handlesvia_obj = new_ok "NoMoo::HandlesVia";

ok ! $moo_obj->can("has"), 'plain Moo: namespace is cleaned';
ok ! $handlesvia_obj->can("has"), 'HandlesVia: namespace is cleaned';

done_testing;
