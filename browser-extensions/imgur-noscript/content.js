'use strict';

const insertImage = data => {
	let image;

	if (data.ext === '.mp4') {
		image = document.createElement('video');
		image.type = 'video/mp4';
		image.controls = true;
		image.loop = true;
		image.autoplay = true;
	} else {
		image = document.createElement('img');
	}

	image.src = 'https://i.imgur.com/' + data.hash + data.ext;

	const container = document.getElementById(data.hash).getElementsByClassName('post-image')[0];
	container.classList.add('image');
	container.appendChild(image);
};

const insertImages = data => {
	if (data.is_album) {
		data.album_images.images.forEach(insertImage);
	} else {
		insertImage(data);
	}
};

const GALLERY_CONFIG = /^\s*widgetFactory\.mergeConfig\('gallery',[^]*?^\s*image\s*:\s*(.+),$/m;

for (const script of document.getElementsByTagName('script')) {
	const match = GALLERY_CONFIG.exec(script.textContent);

	if (match !== null) {
		insertImages(JSON.parse(match[1]));
		break;
	}
}
