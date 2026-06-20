import App from "ags/gtk4/app";
import { Astal, Gdk, Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";

import {
  glancesToJSON,
  bytesToHumanReadable,
  GlancesNetworkStat,
  GlancesCpuStat,
  GlancesMemoryStat,
} from "../lib/glances";
import { Accessor } from "ags";
import { createGestureClick } from "../lib/gesture";
const glancesNetworkStat = glancesToJSON(
  "network",
) as Accessor<GlancesNetworkStat>;
const glancesCpuStat = glancesToJSON("cpu") as Accessor<GlancesCpuStat>;
const glancesMemoryStat = glancesToJSON("mem") as Accessor<GlancesMemoryStat>;

export default function SystemCenter(monitor: Gdk.Monitor) {
  const anchor = Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT;

  const gesture = createGestureClick({
    pressed: (_gesture, _nPress, _x, _y) => {
      App.get_window("systemcenter")!.hide();
    },
  });

  const shutdownClickHandler = createGestureClick({
    pressed: () => {
      execAsync(["shutdown", "now"])
        .then((out) => console.log(out))
        .catch((err) => console.error(err));
    },
  });
  const rebootClickHandler = createGestureClick({
    pressed: () => {
      execAsync(["shutdown", "--reboot", "now"])
        .then((out) => console.log(out))
        .catch((err) => console.error(err));
    },
  });

  const logoutClickHandler = createGestureClick({
    pressed: () => {
      execAsync(["hyprctl", "dispatch", "hl.dsp.exit()"])
        .then((out) => console.log(out))
        .catch((err) => console.error(err));
    },
  });

  return (
    <window
      name="systemcenter"
      namespace="ags-systemcenter"
      application={App}
      class="SystemCenter"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={anchor}
      layer={Astal.Layer.OVERLAY}
      // keymode={Astal.Keymode.EXCLUSIVE}
    >
      <box $={(self) => self.add_controller(gesture)}>
        <box
          class="SystemCenter"
          widthRequest={400}
          heightRequest={300}
          css="background-color: #2b1931; margin: 10px 10px 0 0; border-radius: 20px;"
          orientation={Gtk.Orientation.VERTICAL}
        >
          <box
            css="background-color: #4e2b4f; margin: 10px; border-radius: 15px 15px 10px 10px"
            heightRequest={120}
            class={"MonitorCenter"}
            hexpand={true}
          >
            <button
              $={(self) => self.add_controller(shutdownClickHandler)}
              css="background-color: #4e2b4f"
            >
              <image
                hexpand={true}
                css="font-size: 48px;"
                iconName="shutdown-symbolic"
              />
            </button>
            <button
              $={(self) => self.add_controller(rebootClickHandler)}
              css="background-color: #4e2b4f"
            >
              <image
                hexpand={true}
                css="font-size: 48px;"
                iconName="restart-symbolic"
              />
            </button>
            <button
              $={(self) => self.add_controller(logoutClickHandler)}
              css="background-color: #4e2b4f"
            >
              <image
                hexpand={true}
                css="font-size: 48px;"
                iconName="logout-symbolic"
              />
            </button>
          </box>
          <box
            css="margin: 0px 10px; background-color: #4e2b4f; border-radius: 10px 10px 15px 15px"
            heightRequest={160}
            class={"ControlCenter"}
          >
            <box
              orientation={Gtk.Orientation.VERTICAL}
              halign={Gtk.Align.START}
              vexpand={false}
            >
              <box vexpand={true} css="margin: 0 0 0 20px;">
                <image
                  css="font-size: 20px; margin: 0 10px 0 0;"
                  iconName="cpu-symbolic"
                />
                <slider
                  sensitive={false}
                  widthRequest={280}
                  min={0}
                  max={100}
                  value={glancesCpuStat(({ cpu }) => cpu?.total || 0)}
                />
              </box>
              <box vexpand={true} css="margin: 0 0 0 20px;">
                <image
                  css="font-size: 20px; margin: 0 10px 0 0;"
                  iconName="randomaccessmemory-symbolic"
                />
                <slider
                  sensitive={false}
                  widthRequest={280}
                  min={0}
                  max={100}
                  value={glancesMemoryStat(
                    ({ mem }) => (100 * mem?.used) / mem?.total || 0,
                  )}
                />
              </box>
              <box
                vexpand={true}
                orientation={Gtk.Orientation.HORIZONTAL}
                css="margin: 0 0 0 20px;"
              >
                <image
                  css="font-size: 20px;"
                  iconName="networkspeed-symbolic"
                />
                <label
                  widthChars={20}
                  halign={Gtk.Align.START}
                  xalign={0}
                  label={glancesNetworkStat(({ network }) => {
                    const wifi = network?.find(
                      ({ interface_name }) => interface_name === "wlp3s0",
                    );
                    return (
                      "Sent: " +
                      bytesToHumanReadable(wifi?.bytes_sent_rate_per_sec ?? 0) +
                      "/s"
                    );
                  })}
                />
                <label
                  label={glancesNetworkStat(({ network }) => {
                    const wifi = network?.find(
                      ({ interface_name }) => interface_name === "wlp3s0",
                    );
                    return (
                      "Received: " +
                      bytesToHumanReadable(wifi?.bytes_recv_rate_per_sec ?? 0) +
                      "/s"
                    );
                  })}
                />
              </box>
            </box>
          </box>
        </box>
      </box>
    </window>
  );
}
