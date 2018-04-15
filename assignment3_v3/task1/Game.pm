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

package Game;
use MannerDeckStudent; 
use Player;

sub new {
	my $class = shift @_;
	my @players = ();
	my @cardsOfStack = ();
	my $object = bless {"players"=>\@players,"cardsOfStack"=>\@cardsOfStack}, $class;
	return $object;
}

sub set_players {
	my $self = shift @_;
	my $pName = shift @_;
	my $numOfplayer = $#$pName + 1;
	#my @players = @{$self->{"players"}};
	if(52 % $numOfplayer != 0)
	{
		print "Error: cards' number 52 can not be divided by players number $numOfplayer!\n";
		return 0;
	}
	else
	{
		print "There $numOfplayer players in the game:\n";
		for my $i (@$pName) {
			print "$i ";
			push @{$self->{"players"}},Player->new($i);
		}
		print "\n\n";
		#print ${@players[0]->{"name"}};
		#print $#players;

	}
	return 1;
}

sub getReturn {
	my $self = shift @_;
	my @cardsOfStack = @{$self->{"cardsOfStack"}};
	for (my $i = 0; $i < $#cardsOfStack; $i++)
	{
		if($cardsOfStack[$i] eq $cardsOfStack[$#cardsOfStack])
		{
			my $n = $#cardsOfStack - $i + 1;
			return $n;
		}
		if($cardsOfStack[$#cardsOfStack] eq "J")
		{
			my $n = $#cardsOfStack + 1;
			return $n;
		}
	}
	return 0;
}

sub showCards {
	my $self = shift @_;
	my @cardsOfStack = @{$self->{"cardsOfStack"}};
	if($#cardsOfStack >= 0)
	{
		print "$cardsOfStack[0]"
	}
	for my $i (1..$#cardsOfStack)	{
		print " $cardsOfStack[$i]";
	}
	print "\n";
}

sub start_game {
	print "Game begin!!!\n\n";
	my $self = shift @_;
	my $deck = MannerDeckStudent->new();
	my @players = @{$self->{"players"}};
	$deck->shuffle();
	my $numOfplayer = $#players + 1;
	my $numOflosser = 0;
	#print ${@players[0]->{"name"}}
	my @cards = $deck->AveDealCards($numOfplayer);
	for my $i (0..$#players)
	{
		@{$players[$i]->{"cards"}} = @{$cards[$i]};
	}
	for (my $round = 1; ; $round++)
	{
		for my $i (0..$#players)
		{
			if($players[$i]->numCards() != 0)
			{
				if($numOflosser == $#players)
				{
					print "Winner is ";
					print ${$players[$i]->{"name"}}; 
					print " in game $round\n"; 
					return 1;
				}
				print "Player ";
				print ${$players[$i]->{"name"}};
				my $numOfplayer_card = $players[$i]->numCards();
				print " has $numOfplayer_card cards before deal.\n";
				print "=====Before player's deal=======\n";
				$self->showCards();
				print "================================\n";
				my $newCard = $players[$i]->dealCards();
				push @{$self->{"cardsOfStack"}},$newCard;
				print ${$players[$i]->{"name"}};
				print " ==> card $newCard\n";
				my $n_return = $self->getReturn();
				my @cards_return = ();
				my $have = 0;
				for my $j (1..$n_return)
				{
					my $card_return = pop @{$self->{"cardsOfStack"}};
					push @cards_return,$card_return;
					$have = 1;
				}
				if($have)
				{
					$players[$i]->getCards(@cards_return);
				}
				print "=====After player's deal=======\n";
				$self->showCards();
				print "================================\n";
				print "Player ";
				print ${$players[$i]->{"name"}};
				$numOfplayer_card = $players[$i]->numCards();
				print " has $numOfplayer_card cards after deal.\n";
				if($players[$i]->numCards() == 0)
				{
					print "Player ";
					print ${$players[$i]->{"name"}};
					print " has no cards, out!\n";
					$numOflosser++;
				}
				print "\n";
			}
		}
	}

}

return 1;
