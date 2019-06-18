'use strict';

browser.webRequest.onBeforeRequest.addListener(
	request => ({cancel: true}),
	{urls: ['https://www.google.com/url?*']},
	['blocking'],
);
