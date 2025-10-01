import App from "./App.svelte";
import { mount } from "svelte";

let app: unknown;

const appElement = document.getElementById("app");
if (appElement) {
	app = mount(App, {
		target: appElement,
	});
} else {
	console.error("Failed to initialize the app: #app element not found.");
}
export default app;
