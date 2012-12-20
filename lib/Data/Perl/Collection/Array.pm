package Data::Perl::Collection::Array;

use List::Util;
use List::MoreUtils;
use Scalar::Util qw/blessed/;

require Exporter;

BEGIN { @ISA = qw(Exporter) }

@EXPORT = qw(array);

sub new { my $cl = shift; bless([ @_ ], $cl) }

sub array { Data::Perl::Collection::Array->new(@_) }

sub count { scalar @{$_[0]} }

sub is_empty { scalar @{$_[0]} ? 0 : 1 }

sub elements { @{$_[0]} }

sub get { $_[0]->[ $_[1] ] }

sub pop { pop @{$_[0]} }

sub push { push @{$_[0]}, @_[1..$#_] }

sub shift { shift @{$_[0]} }

sub unshift { unshift @{$_[0]}, @_[1..$#_] }

sub splice { splice @{$_[0]}, $_[1], $_[2], @_[3..$#_] }

sub first { &List::Util::first($_[1], @{$_[0]}) }

sub first_index { &List::MoreUtils::first_index($_[1], @{$_[0]}) }

sub grep {
  my ($self, $cb) = @_;
  grep { $_->$cb } @$self;
}

sub map {
  my ($self, $cb) = @_;
  map { $_->$cb } @$self;
}

sub reduce { List::Util::reduce { $_[1]->($a, $b) } @{$_[0]} }

sub sort { $_[1] ? sort { $_[1]->($a, $b) } @{$_[0]} : sort @{$_[0]} }

sub sort_in_place { @{$_[0]} = ($_[1] ? sort { $_[1]->($a, $b) } @{$_[0]} : sort @{$_[0]}) }

sub shuffle { &List::Util::shuffle(@{$_[0]}) }

sub uniq { &List::MoreUtils::uniq(@{$_[0]}) }

sub join { join $_[1], @{$_[0]} }

sub set { $_[0]->[ $_[1] ] = $_[2] }

sub delete { splice @{$_[0]}, $_[1], 1 }

sub insert { splice @{$_[0]}, $_[1], 0, $_[2] }

sub accessor {
  if (@_ == 2) {
    $_[0]->[$_[1]];
  }
  elsif (@_ > 2) {
    $_[0]->[$_[1]] = $_[2];
  }
}

sub natatime {
  my $iter = List::MoreUtils::natatime($_[1], @{@_[0]});

  if ($_[2]) {
    while (my @vals = $iter->()) {
      $_[2]->(@vals);
    }
  }
  else {
    $iter;
  }
}

sub shallow_clone { blessed($_[0]) ? bless([@{$_[0]}], ref $_[0]) : [@{$_[0]}] }

1;
