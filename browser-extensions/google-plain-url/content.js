'use strict';

for (const link of document.querySelectorAll('a[href^="/url?"]')) {
	const href = link.getAttribute('href');
	const params = new URLSearchParams(href.substring(4));
	link.href = params.get('q');
	link.rel = 'noreferrer';
}

for (const link of document.querySelectorAll('[onmousedown]')) {
	link.onmousedown = null;
	link.rel = 'noreferrer';
}
