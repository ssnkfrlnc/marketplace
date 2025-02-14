import { pluginLess } from '@rsbuild/plugin-less';
import { pluginVue } from '@rsbuild/plugin-vue';
import { defineConfig } from '@rsbuild/core';

export default defineConfig({
  html: {
    template: './index.html',
  },
  plugins: [pluginVue(), pluginLess()],

  source: {
    entry: {
      index: './src/main.ts',
    },
    tsconfigPath: './tsconfig.app.json',
  },
  server: {
    port: 4200,
  },
  output: {
    target: 'web',
    distPath: {
      root: 'dist',
    },
  },
});
