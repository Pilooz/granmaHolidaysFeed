GranmaHohidaysFeed
==================

Introduction
------------

This is an one page web site written in ruby/ramaze that give the last inorfmations about your familie holidays to your Granma.
The feeding of this page is done by twitter, mail, and google maps : you need only an Iphone to contribute...

No local storage needed. Redis caching for the mails.

This page agregates :

* a twitter flow (one account + one hashtag) for 140 char messages !
* a google Maps with your last locations (kml files converted from gpx on the fly).
* a mail feed widget where you can post one picture or a gpx file in attachment for more than 140 chars messages.

GranmaHohidaysFeed has been tested with an Iphone (3GS). 
This could work with other smartphone.

Real Demo
---------

See an example on (![Danube A vélo](http://danubeavelo.famille-levallois.net))

Roadmap
-------

Next TODO:

* trying to take video mime in account in mail attachement     
* explain how to contribute for twitter noobs (Granma ?)
* add localisation for the picture on the map
* Think about image rotations
* internationalisation stuff
* Include charset detection for mailtext
* dealing with serveral attachement ?
* Think about twitter oauth ?
* of course refactor shity code...



Installation
------------