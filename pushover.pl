#!/usr/bin/perl
use strict;
use warnings;

use LWP::UserAgent;
use Getopt::Std;
use Pod::Usage;

my $priority_setting = 0;

my $options = {};
getopt('akmtdurh:sbpi:', $options);
my $usage =<<END;
Usage: $0 [options]
Required:
-a APP_TOKEN\t\tYour application's token
-k USER_KEY\t\tYour user token
-m MESSAGE\t\tThe message you want to send

Optional:
-t TITLE\t\tThe title of your message
-d DEVICE\t\tSend the message only to DEVICE
-u URL\t\t\tA URL to send
-r URL_TITLE\t\tOptional title for the URL
-h\t\t\tThe message is high priority - bypass quiet hours (equivalent to -p 1)
-s UNIX_TIMESTAMP\tUnix timestamp of the message
-b SOUND\t\tThe sound file to play  (see https://pushover.net/api#sounds)
-p PRIORITY\t\tThe priority level to send. -2 (lowest) to 2 (highest). Overrides -h
-i Use STDIN for message input - useful if you want to have new lines in your message
END

if (!defined($options->{'a'}) || !defined($options->{'k'})) {
  pod2usage("Specify APP_TOKEN or USER_KEY");
}

if (!defined($options->{'m'}) && !exists($options->{'i'})) {
  pod2usage("User -m or -i to supply message");
}

$priority_setting = 1 if (defined($options->{'h'}));

# -p overrides priority setting
if (defined($options->{'p'}))
{
  # accept -2,-1,0,1,+1,2,+2
  if ($options->{'p'} !~ /^(-[1-2]|0|\+{0,1}[1-2])$/)
  {
    pod2usage("ERROR: invalid priority value");
  }
  # strip leading +
  ($priority_setting) = ($options->{'p'} =~ s/^\+//g); 
}

delete $options->{'r'} if (defined($options->{'r'}) && !defined($options->{'u'}));

if (exists($options->{'i'})) {
  print "Enter your message (Ctrl+D to send):\n";
  my @message;
  while(<STDIN>) {
    push(@message, $_);
  }
   
  $options->{'m'} = join('', @message);
}

my %push_options = (
    'token' => $options->{'a'},
    'user' => $options->{'k'},
    'message' => $options->{'m'}
  );

$push_options{'title'} = $options->{'t'} if (defined($options->{'t'}));
$push_options{'device'} = $options->{'d'} if (defined($options->{'d'}));
$push_options{'url'} = $options->{'u'} if (defined($options->{'u'}));
$push_options{'url_title'} = $options->{'r'} if (defined($options->{'r'}));
$push_options{'priority'} = $priority_setting;
$push_options{'timestamp'} = $options->{'s'} if (defined($options->{'s'}));
$push_options{'sound'} = $options->{'b'} if (defined($options->{'b'}));

LWP::UserAgent->new()->post("https://api.pushover.net/1/messages", \%push_options);

__END__

=head1 NAME

pushover.pl -- Send pushover notifications from command line

=head1 SYNOPSIS

Usage: **pushover.pl _[options]_**

    Required command-line arguments:  
    -a APP_TOKEN        Your application's token  
    -k USER_KEY         Your User token  
    -m MESSAGE          The message you want to send  

    Optional command-line arguments:
    -t TITLE            The title of your message  
    -d DEVICE           Send the message only to DEVICE  
    -u URL              A URL to send  
    -r URL_TITLE        Optional title for the URL  
    -h                  The message is high priority - bypass quiet hours. Equivalent to -p 1  
    -s UNIX_TIMESTAMP   Unix timestamp of the message 
    -b SOUND            The Sound file to play (see https://pushover.net/api#sounds)
    -p PRIORITY         Priority number (-2 to 2 / Lowest to Highest). Overrides -h 
    -i                  Use STDIN for message input - useful if you want to have new lines in your message

Supplying an application token, a user key and a message is mandatory.
The message can be given either as a command line parameter following the -m argument or interactively using the -i argument. 
The latter case is useful if you want your push message to include new lines

=head1 DESCRIPTION

This is a simple pushover.net client for sending push messages from the command line to devices that have the Pushover app installed.

=cut
