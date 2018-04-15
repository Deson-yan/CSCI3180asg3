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
 
package Server;
use Gpu;
use Task;
our $pid = 0;
our $task = Task->new("a",0);
our $gpu = Gpu->new(-1);
sub new {
	my $class = shift @_;
	my $num = shift @_;
	$num = $num - 1;
	my @gpus = ();
	for my $i (0..$num)
	{
		push @gpus,Gpu->new($i);
	}
	my @waitq = ();
	my $object = bless {"gpus"=>\@gpus,"waitq"=>\@waitq}, $class; 
}
sub task_info {
	return "task(user: ".$task->name().", pid: ".$task->pid().", time: ".$task->time().")";
}
sub task_attr {
	return $task->name(), $task->pid(), $task->time();
}
sub gpu_info {
	return "gpu(id: ".$gpu->id().")";
}
sub submit_task {
	my $self = shift @_;
	my $name = shift @_;
	my $time = shift @_;
	my @gpus = @{$self->{"gpus"}};
	local $task = Task->new($name,$time);
	$task->set_pid($pid);
	for my $i (0..$#gpus)
	{
		if(${$gpus[$i]->{"state"}} == 0)
		{
			$gpus[$i]->assign_task($task);
			$pid = $pid + 1;
			local $gpu = $gpus[$i];
			print task_info();
			print " => ";
			print gpu_info();
			print "\n";
			return 1;
		}
	}
	push @{$self->{"waitq"}},$task;;
	$pid = $pid + 1;
	print task_info;
	print " => ";
	print "waiting queue\n";
	return 1;
}

sub deal_waitq {
	my $self = shift @_;
	my @waitq = @{$self->{"waitq"}};
	my @gpus = @{$self->{"gpus"}};
	if($#waitq < 0)
	{
		return 1;
	}
	else
	{
		for my $i (@gpus)
		{
			if (${$i->{"state"}} == 0)
			{
				local $task = shift @{$self->{"waitq"}};
				$i->assign_task($task);
				print task_info;
				print " => ";
				local $gpu = $i;
				print gpu_info();
				print "\n";
				return 1;
			}
		}
	}
	return 1;
	
}

sub kill_task {
	my $self = shift @_;
	my $name = shift @_;
	my $id = shift @_;
	print "user $name kill ";
	my @gpus = @{$self->{"gpus"}};
	for my $i (@gpus)
	{
		if (${$i->{"state"}} == 1)
		{
			if(${$i->{"task"}}->pid() == $id and ${$i->{"task"}}->name() eq $name)
			{
				local $task = ${$i->{"task"}};
				print task_info;
				print "\n";
				$i->release();
				$self->deal_waitq();
				return 1;
			}
		}
	}
	for my $j ($#{$self->{"waitq"}})
	{
		if(@{$self->{"waitq"}}[$j]->pid() == $id and @{$self->{"waitq"}}[$j]->name() eq $name)
		{
			local $task = @{$self->{"waitq"}}[$j];
			print task_info();
			print "\n";
			@{$self->{"waitq"}} = @{$self->{"waitq"}}[0..$j-1,$j+1..$#{$self->{"waitq"}}];	 
			return 1;
		}
	}

	print "task(pid: $id) fail\n";
	return 1;

}

sub execute_one_time {
	my $self = shift @_;
	my @gpus = @{$self->{"gpus"}};
	print "execute_one_time..\n";
	for my $i (@gpus)
	{
		if (${$i->{"state"}} == 1)
		{
			$i->execute_one_time();
			if(${$i->{"time"}} == ${$i->{"task"}}->time())
			{
				local $gpu = $i;
				my $temp = gpu_info();
				print "task in $temp finished\n";
				$i->release();
				$self->deal_waitq();
			}			
		}
	}
}
sub show {
	my $self = shift @_;
	print "==============Server Message================\n";
	print "gpu-id  state  user  pid  tot_time  cur_time\n";
	my @gpus = @{$self->{"gpus"}};
	my @waitq = @{$self->{"waitq"}};
	for my $i (@gpus)
	{
		my $curr_time = ${$i->{"time"}};
		my $id = ${$i->{"id"}};
		my $name = ${$i->{"task"}}->name();
		local $pid = ${$i->{"task"}}->pid();
		my $time = ${$i->{"task"}}->time();
		if (${$i->{"state"}} == 1)
		{	
			print "  $id     busy   $name    $pid      $time         $curr_time\n";
		}
		else
		{
			print "  $id     idle\n";
		}
	}
	for my $j (@waitq)
	{
		my $name = $j->name();
		local $pid = $j->pid();
		my $time = $j->time();
		print "        wait   $name    $pid      $time\n";
	}
	print "============================================\n\n";
}


return 1;