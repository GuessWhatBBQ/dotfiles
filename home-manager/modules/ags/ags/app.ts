import { App } from "astal/gtk3";
import style from "./style.scss";
import Bar from "./widget/Bar";
import Applauncher from "./widget/Applauncher";
import SystemCenter from "./widget/SystemCenter";
import NotificationPopups from "./widget/NotificationPopups";

App.start({
  css: style,
  icons: `${SRC}/icons`,
  main: () => {
    App.get_monitors().map(Bar);
    Applauncher().hide();
    SystemCenter().hide();
    App.get_monitors().map(NotificationPopups);
    // App.get_monitors().map(SystemCenter);
  },
});
