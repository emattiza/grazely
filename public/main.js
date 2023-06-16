import "./style.css";
import tileUrl from "./assets/tileset.png";
import { Elm } from "../src/Main.elm";

const screenDimensions = [window.innerWidth, window.innerHeight];
const root = document.querySelector("#app div");
const app = Elm.Main.init({ node: root, flags: { tileUrl: tileUrl, dimensions: screenDimensions }});
