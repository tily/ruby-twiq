Twiq
====

Description
-----------

Simple queue system for Twitter.

Usage
-----

        twiq enq user [text]    enqueue status text (if text is not specified, read STDIN lines)
        twiq deq user           dequeue to post to twitter
        twiq list  [user]       list queue
        twiq clear [user]       clear queues (if user is not specified, delete all records)

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

        gem install twiq

Copyright
---------

Copyright (c) 2010 tily. See LICENSE for details.
