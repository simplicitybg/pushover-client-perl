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
    -k USER_KEY         Your application's token  
    -m MESSAGE          The message you want to send  

    Optional command-line arguments:
    -t TITLE            The title of your message  
    -d DEVICE           Send the message only to DEVICE  
    -u URL              A URL to send  
    -r URL_TITLE        Optional title for the URL  
    -h                  The message is high priority - bypass quiet hours  
    -s UNIX_TIMESTAMP   Unix timestamp of the message  
    -i                  Use STDIN for message input - useful if you want to have new lines in your message

---
Supplying an application token, a user key and a message is mandatory.
The message can be given either as a command line parameter following the -m argument or interactively using the -i argument. The latter case is useful if you want your push message to include new lines

## Examples
1. Send a quick message

        pushover.pl -a APP-TOKEN -k USER-KEY -m "Your message"

2. Send a multiline message (useful for sending push notifications from Nagios)

        printf "%b" "This message\nwill span several lines.\nAnd \n characters will be converted to new lines!\n" | pushover.pl -a *APP-TOKEN* -k *USER-KEY* -i
        
## License
pushover-client-perl is released under the MIT license

* http://www.opensource.org/licenses/MIT