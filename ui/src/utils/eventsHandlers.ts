import { CONFIG } from "$data/config.svelte";
import type { DebugEvent, NuiMessage, Result } from "$types/events";
import { onDestroy, onMount } from "svelte";

const debugEventListeners: Record<string, (data: unknown) => unknown> = {};

export async function FetchNUI<T, U>(eventName: string, data?: T): Promise<Result<U>> {
	if (CONFIG.IS_BROWSER) {
		const debugReturn = await DebugNUICallback<T>(eventName, data);
		return debugReturn as U;
	}
	const options = {
		method: "post",
		headers: {
			"Content-Type": "application/json; charset=UTF-8",
		},
		body: JSON.stringify(data),
	};
	const resp: Response = await fetch(
		`https://${CONFIG.RESOURCE_NAME}/${eventName}`,
		options,
	);
	return await resp.json();
}

export function SendNUI<T>(eventName: string, data?: T): void {
	if (CONFIG.IS_BROWSER) {
		DebugNUICallback<T>(eventName, data);
		return;
	}

	const options = {
		method: "post",
		headers: {
			"Content-Type": "application/json; charset=UTF-8",
		},
		body: JSON.stringify(data),
	};

	fetch(`https://${CONFIG.RESOURCE_NAME}/${eventName}`, options);
}

export function ReceiveNUI<T = unknown>(
	action: string,
	handler: (data: T) => void,
) {
	const eventListener = (event: MessageEvent<NuiMessage<T>>) => {
		const { action: eventAction, data } = event.data;

		eventAction === action && handler(data);
	};

	onMount(() => window.addEventListener("message", eventListener));
	onDestroy(() => window.removeEventListener("message", eventListener));
}

export async function SendDebugNUI<P>(event: DebugEvent<P>, timer = 0) {
	if (!CONFIG.IS_BROWSER) return;
	setTimeout(() => {
		window.dispatchEvent(
			new MessageEvent("message", {
				data: {
					action: event.action,
					data: event.data,
				},
			}),
		);
	}, timer);
}

export async function ReceiveDebugNUI<T>(
	action: string,
	handler?: (data: T) => unknown,
) {
	if (!CONFIG.IS_BROWSER) return;
    console.log(`[DEBUG] Adding debug receiver for ${action} event.`);
	if (debugEventListeners[action] !== undefined) {
		console.log(
			`%c[DEBUG] %c${action} %cevent already has a debug receiver.`,
			"color: red; font-weight: bold;",
			"color: green",
			"",
		);
        return debugEventListeners[action];
	}
    
	debugEventListeners[action] = (data: unknown) => {
        console.log(`%c[DEBUG]%c Received %c${action} %cevent with data:${data}`,
            "color: green;",
            "color: white;",
            "color: yellow;",
            "color: white;"
        );
		return handler ? handler(data as T) : {};
	};
}

export async function DebugNUICallback<T>(action: string, data?: T) {
	if (!CONFIG.IS_BROWSER) {
		return {};
	}

	const handler = debugEventListeners[action];
	if (handler === undefined) {
		console.warn(
            `%c[DEBUG] %c${action} event does not have a debugger.`
            , "color: red; font-weight: bold;"
            , "color: green;"
        );
            
        return {};
	}
    
    const new_handler = (data: unknown) => {
        console.log(
            `%c[DEBUG] %cCalling handler for %c${action}`
            , "color: green;"
            , "color: white;"
            , "color: yellow;"
        );
        return handler(data);
    }

	const result = await new_handler(data);
	return result
}
