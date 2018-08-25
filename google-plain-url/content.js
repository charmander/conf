'use strict';

for (const link of document.querySelectorAll('a[href^="/url?"]')) {
	const href = link.getAttribute('href');
	const params = new URLSearchParams(href.substring(4));
	link.href = params.get('q');
	link.rel = 'noreferrer';
}

window.addEventListener('mousedown', e => {
	if (e.target.onmousedown !== null) {
		e.stopPropagation();
	}
}, true);
