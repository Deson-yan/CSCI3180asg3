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

package Gpu;
use Task;
sub new {
	my $class = shift @_;
	my $id = shift @_;
	my $state = 0;
	my $task = Task->new("null",0);
	my $time = 0;
	my $pid = 0;
	my $object = bless {"state"=>\$state,"task"=>\$task,"id"=>\$id,"time"=>\$time}, $class;
	return $object;
}
sub assign_task {
	my $self = shift @_;
	my $task = shift @_;
	${$self->{"task"}} = $task;
	${$self->{"time"}} = 0;
	${$self->{"state"}} = 1;
	return 1;
}
sub release {
	my $self = shift @_;
	${$self->{"task"}} = Task->new("null",0);
	${$self->{"time"}} = 0;
	${$self->{"state"}} = 0;
	return 1;
}
sub execute_one_time {
	my $self = shift @_;
	${$self->{"time"}} = ${$self->{"time"}} + 1;
	return 1;
}
sub id {
	my $self = shift @_;
	my $id = ${$self->{"id"}};
	return $id;
}

return 1;
