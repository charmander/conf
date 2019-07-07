'use strict';

browser.webRequest.onBeforeRequest.addListener(
	request => ({cancel: true}),
	{
		urls: ['https://*.thumbs.redditmedia.com/*.css'],
		types: ['stylesheet'],
	},
	['blocking'],
);

browser.webRequest.onBeforeRequest.addListener(
	request => {
		const target = new URL(request.url);

		if (target.hostname === 'old.reddit.com') {
			return {};
		}

		target.hostname = 'old.reddit.com';
		return {redirectUrl: String(target)};
	},
	{
		urls: ['https://*.reddit.com/*'],
		types: ['main_frame'],
	},
	['blocking'],
);
