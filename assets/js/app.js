// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

// Define hooks
const Hooks = {}

// Theme hook to update document theme
Hooks.Theme = {
  mounted() {
    this.handleEvent("update-theme", ({ theme }) => {
      console.log("Changing theme to:", theme);
      // Update both the document and the container
      document.documentElement.setAttribute("data-theme", theme);
      this.el.setAttribute("data-theme", theme);
      console.log("Document theme attribute is now:", document.documentElement.getAttribute("data-theme"));
    });
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      // Preserve data-theme attribute when the DOM is updated
      if (from.getAttribute("data-theme") && !to.getAttribute("data-theme")) {
        to.setAttribute("data-theme", from.getAttribute("data-theme"));
      }
      return to;
    }
  }
})

// Handle js-exec events
window.addEventListener("phx:js-exec", ({ detail }) => {
  document.querySelectorAll(detail.to).forEach(el => {
    el.setAttribute(detail.attr, detail.val);
    // Also update document element if we're changing theme
    if (detail.attr === "data-theme") {
      document.documentElement.setAttribute("data-theme", detail.val);
    }
  });
});

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

