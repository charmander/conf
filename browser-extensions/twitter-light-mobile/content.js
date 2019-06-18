'use strict';

const hidden = (name, value) =>
	Object.assign(document.createElement('input'), {
		type: 'hidden',
		name,
		value,
	});

const form = document.createElement('form');
form.id = 'show-media-fix-form';
form.hidden = true;

const params = new URLSearchParams(location.search);

for (const [key, value] of params) {
	form.appendChild(hidden(key, value));
}

form.appendChild(hidden('show_media', '1'));

document.body.appendChild(form);

for (const button of document.querySelectorAll('input[name="commit"][value="Display media"]')) {
	button.setAttribute('form', form.id);
	button.name = '';
}

for (const link of document.getElementsByClassName('has-expanded-path')) {
	link.href = link.getAttribute('data-expanded-path');
}
