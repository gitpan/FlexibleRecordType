#!/usr/bin/perl -w

BEGIN
{
	unshift(@INC,"/home/london/perl");
}


use Data::Dumper;

use FlexibleRecordType;

# declare the type
# i.e. declare what a record will look like for a mailing label.
 my $mailing_label = New FlexibleRecordType('Name', 'State', 'ZIP');


# create instances of the record type

 my %home_address;
 $mailing_label->Instance(\%home_address);
 $home_address{'Name'} = 'Greg';
 $home_address{'State'} = 'XI';
 $home_address{'ZIP'} = '12345';

 my %work_address;
 $mailing_label->Instance(\%work_address);
 $work_address{'Name'} = 'Mr. London';
 $work_address{'State'} = 'QA';
 $work_address{'ZIP'} = '33333';

 my %play_address;
 $mailing_label->Instance(\%play_address);
 $play_address{'Name'} = 'Chopper';
 $play_address{'State'} = 'DO';
 $play_address{'ZIP'} = '98765';



 print Dumper \%home_address;

# delete an element name from all record instances.
 delete $home_address{'ZIP'};
 print Dumper \%home_address;




#	$work_address->DeleteInstance;

 # show that the work_address instance was deleted from the master list
 # of all instances for the mailing label type record.
# print Dumper $home_address;


