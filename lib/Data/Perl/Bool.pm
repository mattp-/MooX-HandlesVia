package Data::Perl::Bool;

sub new { my $cl = shift; bless(\(!!$_[0])), $cl }

sub set { $$_[0] = !!$_[1] }

sub unset { $$_[0] = 0 }

sub toggle { $$_[0] = $$_[0] ? 0 : 1; }

sub not { $$_[0] = !$$_[0] }

1;
