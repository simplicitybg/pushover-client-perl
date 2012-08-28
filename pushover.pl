#!/usr/bin/perl
use strict;
use warnings;

use LWP::UserAgent;
use Getopt::Std;

my $options = {};
getopt('akmtdurh:si:', $options);
my $usage =<<END;
Usage: $0 [options]
Required:
-a APP_TOKEN\t\tYour application's token
-k USER_KEY\t\tYour application's token
-m MESSAGE\t\tThe message you want to send

Optional:
-t TITLE\t\tThe title of your message
-d DEVICE\t\tSend the message only to DEVICE
-u URL\t\t\tA URL to send
-r URL_TITLE\t\tOptional title for the URL
-h\t\t\tThe message is high priority - bypass quiet hours
-s UNIX_TIMESTAMP\tUnix timestamp of the message
-i Use STDIN for message input - useful if you want to have new lines in your message
END

if (!defined($options->{'a'}) || !defined($options->{'k'})) {
  print $usage;
  exit(1);
}

if (!defined($options->{'m'}) && !exists($options->{'i'})) {
  print $usage;
  exit(1);
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
$push_options{'priority'} = 1 if (defined($options->{'h'}));
$push_options{'timestamp'} = $options->{'s'} if (defined($options->{'s'}));

LWP::UserAgent->new()->post("https://api.pushover.net/1/messages", \%push_options);
