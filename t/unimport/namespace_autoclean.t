# cleaning the namespace using 'namespace::clean'
use strict;
use warnings;

use Test::More;

eval { require namespace::autoclean };
plan skip_all => "namespace::autoclean is required for this test" if $@;

eval <<END
    package Autoclean::Moo;
    use namespace::autoclean;
    use Moo;
END
;

eval <<END
    package Autoclean::HandlesVia;
    use namespace::autoclean;
    use Moo;
    use MooX::HandlesVia;
END
;

my $moo_obj = new_ok "Autoclean::Moo";
my $handlesvia_obj = new_ok "Autoclean::HandlesVia";

ok ! $moo_obj->can("has"), 'plain Moo: namespace is cleaned';
ok ! $handlesvia_obj->can("has"), 'HandlesVia: namespace is cleaned';

done_testing;
