'use strict';

browser.webRequest.onHeadersReceived.addListener(
	({responseHeaders}) => {
		responseHeaders.push({
			name: 'Content-Security-Policy',
			// TODO: check whether the specific directives are necessary once implemented
			value: "script-src 'none'; script-src-elem 'none'; script-src-attr 'none'",
		});

		return {responseHeaders};
	},
	{
		types: ['main_frame'],
		urls: ['https://www.google.com/*'],
	},
	['blocking', 'responseHeaders'],
);

browser.webRequest.onBeforeRequest.addListener(
	request => ({cancel: true}),
	{urls: ['https://www.google.com/url?*']},
	['blocking'],
);
