import { getRenderer } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/transport/renderer.js';
import { initJssCs } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/transport/setup-jss.js';initJssCs();
import { installTheme } from '/mnt/dev/godot/golden_gadget/.codedoc/content/theme.ts';installTheme();
import { codeSelection } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/code/selection.js';codeSelection();
import { sameLineLengthInCodes } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/code/same-line-length.js';sameLineLengthInCodes();
import { initHintBox } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/code/line-hint/index.js';initHintBox();
import { initCodeLineRef } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/code/line-ref/index.js';initCodeLineRef();
import { initSmartCopy } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/code/smart-copy.js';initSmartCopy();
import { copyHeadings } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/heading/copy-headings.js';copyHeadings();
import { contentNavHighlight } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/page/contentnav/highlight.js';contentNavHighlight();
import { loadDeferredIFrames } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/transport/deferred-iframe.js';loadDeferredIFrames();
import { smoothLoading } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/transport/smooth-loading.js';smoothLoading();
import { tocHighlight } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/page/toc/toc-highlight.js';tocHighlight();
import { postNavSearch } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/page/toc/search/post-nav/index.js';postNavSearch();
import { reloadOnChange } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/serve/reload.js';reloadOnChange();
import { ToCPrevNext } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/page/toc/prevnext/index.js';
import { ToCToggle } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/page/toc/toggle/index.js';
import { DarkModeSwitch } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/components/darkmode/index.js';
import { ConfigTransport } from '/mnt/dev/godot/golden_gadget/.codedoc/node_modules/@codedoc/core/dist/es6/transport/config.js';

const components = {
  'z2F3XqEzdQUl9R5iISGZtg==': ToCPrevNext,
  '4XMC1NeTEykJLzeFI8DSLw==': ToCToggle,
  'DsgX5+z3QZJ9FJUH2iwk8w==': DarkModeSwitch,
  'B4Kk3spEGG1aHAK8LunwuQ==': ConfigTransport
};

const renderer = getRenderer();
const ogtransport = window.__sdh_transport;
window.__sdh_transport = function(id, hash, props) {
  if (hash in components) {
    const target = document.getElementById(id);
    renderer.render(renderer.create(components[hash], props)).after(target);
    target.remove();
  }
  else if (ogtransport) ogtransport(id, hash, props);
}
