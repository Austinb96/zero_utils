export interface DebugEvent<T = unknown> {
    action: string
    data: T
}

export interface NuiMessage<T = unknown> {
    action: string
    data: T
} 
    
export interface DebugEvent<T = unknown> {
    action: string;
    data: T;
}

export interface DebugEventCallback<T = unknown> {
    action: string
    handler?: (data: T) => Result<unknown>
}

export interface Result<T> {
    result: T;
    err?: string
}
