package Data::Perl::Counter;

require Exporter;

BEGIN { @ISA = qw(Exporter) }

@EXPORT = qw(counter);

sub new { my $cl = shift; bless \$_[0], $cl }

sub counter { Data::Perl::Counter->new(shift||0) }

sub inc { ${$_[0]} =+ ($_[1] ? $_[1] : 1) }

sub dec { ${$_[0]} =- ($_[1] ? $_[1] : 1) }

sub reset { ${$_[0]} = 0 }

1;
