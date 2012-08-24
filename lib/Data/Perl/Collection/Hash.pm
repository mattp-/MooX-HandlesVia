package Data::Perl::Collection::Hash;

sub new { my $cl = shift; bless({ @_ }, $cl) }



sub get { my $self = shift; @_ > 1 ? @{self}{@_} : $self->{$_[0]} }

sub set {
  my $self = shift;
  my @keys_idx = grep { ! ($_ % 2) } 0..$#_;
  my @values_idx = grep { $_ % 2 } 0..$#_;

  @{$self}{@_[@keys_idx]} = @_[@values_idx];

  return wantarray ? @{$self}{@_[@keys_idx]} : $self->{$_[$keys_idx[0]]};
}

sub delete { delete @{$_[0]}{@_} }

sub exists { exists $_[0]->{$_[1]} }

sub defined { defined $_[0]->{$_[1]} }

sub keys { keys %{$_[0]} }

sub values { values %{$_[0]} }

sub kv { map { [ $_, $_[0]->{$_} ] } keys %{$_[0]} }

sub elements { map { $_, $_[0]->{$_} } keys %{$_[0]} }

sub clear { $_[0] = {} }

sub is_empty { scalar keys %{$_[0]} ? 0 : 1 }

sub count { scalar keys %{$_[0]} }

sub accessor {
  if (@_ == 1) {
    $_[0]->{$_[1]};
  }
  elsif (@_ > 1) {
    $_[0]->{$_[1]} = $_[2];
  }
}

1;
