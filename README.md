Twiq
====

Description
-----------

Simple queue system for Twitter.

Usage
-----

        enq user [text]    enqueue status text (if text is not specified, read STDIN lines)
        deq user           dequeue to post to twitter
        list [user]        list queue
        help               show this help
        clear [user]       clear queues (if user is not specified, delete all records)

Note
----

 * creates pit entry "twiq-[username]"
 * creates database file "~/.twiq"

Requirement
-----------

 * sequel
 * oauth-cli-twitter

Install
-------

### Archive Installation

        rake install

### Gem Installation

        gem install twiq

Copyright
---------

Copyright (c) 2010 tily. See LICENSE for details.
