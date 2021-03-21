// Add this to your lovelace resources as
// url: /local/chart-colors.js
// type: module


//  00ff00 ../images/veryhigh
//  00cc00 ../images/high
//  00aa00 ../images/nominal
//  ffaa00 ../images/low
//  ff0000 ../images/verylow
//  bb0000 ../images/none
//  800000 ../images/null
//  440000 ../images/unknown

customElements.whenDefined('ha-chart-base').then(() => {

  // Find the HaChartBase class
  const HaChartBase = customElements.get('ha-chart-base');


  function getColorList(cnt) {
      let retval = [
	Color().rgb(255,0,0), // red
	Color().rgb(0,255,0), // green
	Color().rgb(0,0,255), // blue
      ];
      
      return retval.slice(0, cnt);
  }

  // Replace the color list generator in the base class
  HaChartBase.getColorList = getColorList;

  // Force lovelace to redraw everything
  const  ev = new Event("ll-rebuild", {
      bubbles: true,
      cancelable: false,
      composed: true,
  });
  var root = document.querySelector("home-assistant");
  root = root && root.shadowRoot;
  root = root && root.querySelector("home-assistant-main");
  root = root && root.shadowRoot;
  root = root && root.querySelector("app-drawer-layout partial-panel-resolver");
  root = root && root.shadowRoot || root;
  root = root && root.querySelector("ha-panel-lovelace");
  root = root && root.shadowRoot;
  root = root && root.querySelector("hui-root");
  root = root && root.shadowRoot;
  root = root && root.querySelector("ha-app-layout #view");
  root = root && root.firstElementChild;
  if (root) root.dispatchEvent(ev);
});
