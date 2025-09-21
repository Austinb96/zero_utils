import { SendDebugNUI } from "$utils/eventsHandlers";
import type { DebugEvent } from "$types/events";

const InitDebug: DebugEvent[] = [
	{
		action: "enableUI",
		data: true,
	},
];

export default InitDebug;

export function InitializeDebugSenders(): void {
	for (const event of InitDebug) {
		SendDebugNUI({
			action: event.action,
			data: event.data,
		});
	}
}
