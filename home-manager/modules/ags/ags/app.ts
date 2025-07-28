import app from "ags/gtk4/app";
import GLib from "gi://GLib";
import { Gtk } from "ags/gtk4";
import style from "./style.scss";
import Bar from "./widget/Bar";
import Applauncher from "./widget/Applauncher";
import SystemCenter from "./widget/SystemCenter";
import NotificationPopups from "./widget/NotificationPopups";

let applauncher: Gtk.Window;

app.start({
  css: style,
  icons: `${SRC}/icons`,
  requestHandler(request, res) {
    const [, argv] = GLib.shell_parse_argv(request);
    if (!argv) return res("argv parse error");

    switch (argv[0]) {
      case "toggle":
        applauncher.visible = !applauncher.visible;
        return res("ok");
      default:
        return res("unknown command");
    }
  },
  main: () => {
    app.get_monitors().map(Bar);
    applauncher = Applauncher() as Gtk.Window;
    app.add_window(applauncher);
    applauncher.present();
    // SystemCenter();
    NotificationPopups();
    app.get_monitors().map(SystemCenter);
  },
});
