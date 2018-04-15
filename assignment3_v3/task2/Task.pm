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

package Task;
sub new {
	my $class = shift @_;
	my $name = shift @_;
	my $time = shift @_;
	my $pid = 0;
	my $object = bless {"name"=>\$name,"time"=>\$time,"pid"=>\$pid}, $class;
	return $object;
}
sub pid {
	my $self = shift @_;
	my $pid = ${$self->{"pid"}};
	return $pid;
}
sub name {
	my $self = shift @_;
	my $name = ${$self->{"name"}};
	return $name;
}
sub time {
	my $self = shift @_;
	my $time = ${$self->{"time"}};
	return $time;
}

sub set_pid{
	my $self = shift @_;
	my $pid = shift @_;
	${$self->{"pid"}} = $pid;
	return 1;
}
return 1;
