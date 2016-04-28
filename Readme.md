# pushover-client-perl
This is a simple pushover.net client for sending push messages from the command line to devices that have the Pushover app installed.

## Requirements
- Pushover.net account
- Pushover.net [app token](https://pushover.net/apps/build)
- Device with the [pushover device client](https://pushover.net/clients) installed
- Perl
- Perl modules:
- LWP::UserAgent
- Getopt::Std  

## Usage
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

---
Supplying an application token, a user key and a message is mandatory.
The message can be given either as a command line parameter following the -m argument or interactively using the -i argument. The latter case is useful if you want your push message to include new lines

## Examples
1. Send a quick message

        pushover.pl -a APP-TOKEN -k USER-KEY -m "Your message"

2. Send a multiline message (useful for sending push notifications from Nagios)

        printf "%b" "This message\nwill span several lines.\nAnd \n characters will be converted to new lines!\n" | pushover.pl -a *APP-TOKEN* -k *USER-KEY* -i
       

## Notes
At of the last update of this script, the valid Sound files (-s parameter) defined on pushover.net were:

  pushover - Pushover (default)
  bike - Bike
  bugle - Bugle
  cashregister - Cash Register
  classical - Classical
  cosmic - Cosmic
  falling - Falling
  gamelan - Gamelan
  incoming - Incoming
  intermission - Intermission
  magic - Magic
  mechanical - Mechanical
  pianobar - Piano Bar
  siren - Siren
  spacealarm - Space Alarm
  tugboat - Tug Boat
  alien - Alien Alarm (long)
  climb - Climb (long)
  persistent - Persistent (long)
  echo - Pushover Echo (long)
  updown - Up Down (long)
  none - None (silent)


## License
pushover-client-perl is released under the MIT license

* http://www.opensource.org/licenses/MIT
