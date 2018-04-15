#
# CSCI3180 Principles of Programming Languages ∗
# --- Declaration --- ∗
# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/ ∗
# Assignment 3
# Name : YAN Shen
# Student ID : 1155092213
# Email Addr : syan6@cse.cuhk.edu.hk
#
use strict;
use warnings;
 
package Player;
sub new {
	my $class = shift @_;
	my $name = shift @_;
	my @cards = ();
	my $object = bless {"name"=>\$name, "cards"=>\@cards}, $class;
	return $object;
}

sub getCards {
	my $self = shift @_;
	my @cards = @_;
	for my $i (0..$#cards)
	{
		push @{$self->{"cards"}},$cards[$i];
	}
}

sub dealCards {
	my $self = shift @_;
	my $topCard = shift @{$self->{"cards"}};
	return $topCard;
}

sub numCards {
	my $self = shift @_;
	my @cards = @{$self->{"cards"}};
	my $len = $#cards + 1;
	return $len;
}

return 1;