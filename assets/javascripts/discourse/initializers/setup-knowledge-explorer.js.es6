import { withPluginApi } from "discourse/lib/plugin-api";

function initialize(api) {
  api.decorateWidget("hamburger-menu:generalLinks", () => {
    return {
      route: "knowledgeExplorer",
      label: "chord_directory.title",
      className: "chord-directory-link"
    };
  });

  api.addKeyboardShortcut("g e", "", { path: "/docs" });
}

export default {
  name: "setup-chord-directory",

  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    if (!siteSettings.chord_directory_enabled) {
      return;
    }
    withPluginApi("0.8", api => initialize(api, container));
  }
};
