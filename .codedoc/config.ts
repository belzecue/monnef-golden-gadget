import {configuration} from '@codedoc/core';

import {theme} from './theme';


export const config = /*#__PURE__*/configuration({
  theme,                                  // --> add the theme. modify `./theme.ts` for chaning the theme.

  page: {
    title: {
      base: 'Golden Gadget'               // --> the base title of your doc pages
    }
  },

  dest: {
    html: 'docs/dist',
    assets: 'docs/dist',
    bundle: '.',
    styles: '.',
    namespace: '/golden-gadget'
  }

});
