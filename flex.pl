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

 my $home_address = $mailing_label->Instance;
    $home_address->Value('State','XI');
    $home_address->Value('ZIP','12345');
    $home_address->Value('Name','NameAtHome');

 my $work_address = $mailing_label->Instance;
    $work_address->Value('Name','Mr London');

 my $play_address = $mailing_label->Instance;
    $play_address->Value('Name','Chopper Head');

 #show all records and all values
 print Dumper $home_address;
	

# delete an element name from all record instances.
	$home_address->DeleteElement('State');

 #show that none of the records have the element for "State" any more.
 print Dumper $home_address;

	
    $work_address->DeleteInstance;

 # show that the work_address instance was deleted from the master list
 # of all instances for the mailing label type record.
 print Dumper $home_address;


