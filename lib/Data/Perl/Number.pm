package Data::Perl::Number;

sub new { my $cl = shift; bless(\$_[0]), $cl }

sub add { $$_[0] = $$_[0] + $_[1] }

sub sub { $$_[0] = $$_[0] - $_[1] }

sub mul { $$_[0] = $$_[0] * $_[1] }

sub div { $$_[0] = $$_[0] / $_[1] }

sub mod { $$_[0] = $$_[0] % $_[1] }

sub abs { $$_[0] = abs($$_[0]) }

1;
