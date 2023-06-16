import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";

export default defineConfig({
  root: "public",
  server: { hmr: { clientPort: 443 } },
  base: "/grazely/",
  plugins: [elmPlugin()],
});
