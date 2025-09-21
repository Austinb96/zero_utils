import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import { viteSingleFile } from "vite-plugin-singlefile"
import path from "path";


// https://vitejs.dev/config/
export default defineConfig(({ command, mode }) => {
    console.log(`Running in ${mode} mode`);
    const isProduction = mode === 'production';

    return {
        plugins: [
            svelte(),
            // Use singleFile plugin only in production to bundle everything into one HTML
            isProduction ? viteSingleFile() : null,
        ].filter(Boolean),
        base: "./",
        resolve: {
            alias: {
                $_browser: path.resolve("./src/_browser"),
                $assets: path.resolve("./src/assets"),
                $data: path.resolve("./src/data"),
                $lib: path.resolve("./src/lib"),
                $components: path.resolve("./src/lib/components"),
                $providers: path.resolve("./src/providers"),
                $types: path.resolve("./src/types"),
                $utils: path.resolve("./src/utils"),
            },
        },
        build: {
            outDir: "build",
            minify: isProduction,
            cssMinify: isProduction,
            cssCodeSplit: !isProduction,
            rollupOptions: {
                output: {
                    inlineDynamicImports: isProduction, 
                    manualChunks: undefined,
                    format: isProduction ? "iife" : 'es',
                },
            },
        },
    };
});
