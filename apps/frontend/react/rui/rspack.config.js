const { composePlugins, withNx, withWeb } = require('@nx/rspack');
const { ReactRefreshPlugin } = require('@rspack/plugin-react-refresh');

module.exports = composePlugins(withNx(), withWeb(), (config, { mode }) => {
  // Add React Refresh plugin in development mode
  if (mode === 'development') {
    config.plugins.push(new ReactRefreshPlugin());
  }

  // Ensure JS/TS files are processed with Rspack's React Refresh loader
  config.module ??= {};
  config.module.rules ??= [];
  config.module.rules.push({
    test: /\.(js|jsx|ts|tsx)$/,
    use: {
      loader: 'builtin:swc-loader',
      options: {
        jsc: {
          transform: {
            react: {
              development: mode === 'development',
              refresh: mode === 'development',
            },
          },
        },
      },
    },
  });

  return config;
});
