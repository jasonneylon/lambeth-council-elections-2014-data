There should be open data on who is standing in elections right? Well if there is I couldn't find it. Instead I downloaded the PDFs that listed candidates from [Lambeth website](http://www.lambeth.gov.uk/elections-and-council/elections/statements-of-persons-nominated-to-stand-in-the-local-elections-on). I used the [the command line version](https://github.com/jazzido/tabula-extractor) of [Tabula](http://tabula.nerdpower.org/) to extract the data. I then geocoded the data using [MySociety's fantastic MapIt](http://mapit.mysociety.org/) API. All the data and code is on [github](https://github.com/jasonneylon/lambeth-council-elections-2014-data/).

Check out the [How local are party candidates for the Lambeth council elections blog post](http://jasonneylon.wordpress.com/2014/05/21/how-local-are-party-candidates-for-the-lambeth-council-elections/) for more info.

## Setup ##

Uses tabula.

    jruby -S gem install tabula-extractor 

