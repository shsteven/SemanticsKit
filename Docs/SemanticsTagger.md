## Querying
a -getTagsAtRange:withBlock: method, that inspect the current NSRange and returns a dictionary

Design: inspirations from NSLinguisticTagger, NSRegex


## Taggers
@protocol ZSSematicsTagger

Each tagger has one or many rules to determine valid ranges

Each tagger only does one thing, and keeps track of a mapping

RangeMap

NSArray * (sorted by startLocation, no overlap allowed)

Ranges:
	1,3
	10, 2
	…









## Proposed working mechanism

- Regular expression ruleset
- GCD
- Lazy scanning

### Types

Name
@todo Capture the rest of the line
@whatever
http://stackoverflow.com/questions/11846975/javascript-regex-for-matching-twitter-like-hashtags
xxx @mention

\S*#(?:\[[^\]]+\]|\S+)
#hashtag
