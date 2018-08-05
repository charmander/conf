'use strict';

browser.webRequest.onBeforeSendHeaders.addListener(
	details => ({
		requestHeaders: details.requestHeaders.filter(
			header =>
				!/^user-agent$/i.test(header.name)
		),
	}),
	{urls: ['https://mobile.twitter.com/*']},
	['blocking', 'requestHeaders'],
);
