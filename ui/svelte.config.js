import {sveltePreprocess} from 'svelte-preprocess';
export default {
	preprocess: sveltePreprocess(),
	kit: {
		paths: {
			relative: false
		},
	}
};
