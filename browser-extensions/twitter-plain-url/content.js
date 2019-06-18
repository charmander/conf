'use strict';

const expand = attribute => {
	for (const link of document.querySelectorAll(`a[${attribute}]`)) {
		link.href = link.getAttribute(attribute);

		if (link.href === link.title) {
			link.title = '';
		}

		link.rel += ' noreferrer';
	}
};

[
	'data-expanded-url',  // external timeline links
	'data-url',           // user website link and embed links on light mobile.twitter.com
].forEach(expand);

// user website link on twitter.com and all links on heavy mobile.twitter.com
for (const link of document.querySelectorAll('a[href^="https://t.co"][title^="http"]')) {
	link.href = link.title;
	link.title = '';
	link.rel += ' noreferrer';
}

// embed links on twitter.com and heavy mobile.twitter.com can’t be expanded; I recommend light mobile.twitter.com (change User-Agent header for mobile.twitter.com to something that doesn’t suggest JavaScript support)
