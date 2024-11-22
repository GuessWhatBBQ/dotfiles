import { App } from "astal/gtk3";
import { Variable, GLib, bind } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import BT from "gi://AstalBluetooth";
import Wp from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";

function SysTray() {
  const tray = Tray.get_default();

  return (
    <box css=" background: #4E2B4F; border-radius: 10px 3px 3px 10px; padding: 0 5px; margin: 3px 2px; ">
      {bind(tray, "items").as((items) =>
        items.map((item) => {
          if (item.iconThemePath) App.add_icons(item.iconThemePath);

          const menu = item.create_menu();

          return (
            <button
              tooltipMarkup={bind(item, "tooltipMarkup")}
              onDestroy={() => menu?.destroy()}
              onClickRelease={(self) => {
                menu?.popup_at_widget(
                  self,
                  Gdk.Gravity.SOUTH,
                  Gdk.Gravity.NORTH,
                  null,
                );
              }}
            >
              <icon gIcon={bind(item, "gicon")} />
            </button>
          );
        }),
      )}
    </box>
  );
}

function Wifi() {
  const { wifi } = Network.get_default();

  return (
    <icon
      tooltipText={bind(wifi, "ssid").as(String)}
      className="Wifi"
      icon={bind(wifi, "iconName")}
    />
  );
}

function Bluetooth() {
  const bluetooth = BT.get_default();

  const iconName = Variable.derive(
    [bind(bluetooth, "isPowered"), bind(bluetooth, "isConnected")],
    (isPowered, isConnected) => {
      if (isPowered && isConnected) {
        return "bluetooth-connect";
      } else if (bluetooth.isPowered) {
        return "bluetooth";
      } else {
        return "bluetooth-off";
      }
    },
  );

  const devices = Variable.derive([bind(bluetooth, "devices")], (devices) => {
    return devices
      .filter((device) => device.connected)
      .map((device) => device.alias)
      .join("\n");
  });

  return (
    <box>
      {
        <icon
          icon={bind(iconName).as((i) => `${i}-symbolic`)}
          tooltipText={bind(devices).as(String)}
        />
      }
    </box>
  );
}

function Peripherals() {
  return (
    <box
      hexpand
      halign={Gtk.Align.END}
      css=" background: #4E2B4F; border-radius: 3px 10px 10px 3px; padding: 0 5px; margin: 3px 2px; "
    >
      <Wifi />
      <Bluetooth />
      <Audio />
    </box>
  );
}

function SysStat() {
  return (
    <box
      hexpand
      halign={Gtk.Align.END}
      css=" background: #4E2B4F; border-radius: 3px; padding: 0 5px; margin: 3px 2px; "
    >
      <BatteryLevel />
    </box>
  );
}

function Audio() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!;

  return (
    <box>
      <eventbox
        onClick={() => {
          speaker.set_mute(!speaker.get_mute());
        }}
      >
        <icon
          icon={bind(speaker, "volumeIcon")}
          tooltipText={bind(speaker, "volume").as(
            (v) => `${Math.round(v * 100)}%`,
          )}
        />
      </eventbox>
    </box>
  );
}

function BatteryLevel() {
  const bat = Battery.get_default();

  return (
    <box className="Battery" visible={bind(bat, "isPresent")}>
      <icon
        icon={bind(bat, "batteryIconName")}
        tooltipText={bind(bat, "percentage").as((p) => `${p * 100}%`)}
      />
    </box>
  );
}

function Workspaces() {
  const hypr = Hyprland.get_default();

  return (
    <box className="Workspaces">
      {bind(hypr, "workspaces").as((wss) =>
        wss
          .sort((a, b) => a.id - b.id)
          .map((ws) => (
            <button
              className={bind(hypr, "focusedWorkspace").as((fw) =>
                ws === fw ? "focused" : "",
              )}
              onClicked={() => ws.focus()}
              css="margin: 3px;"
            >
              <icon
                icon={bind(hypr, "focusedWorkspace").as((fw) =>
                  ws === fw ? "circle-symbolic" : "circle-outline-symbolic",
                )}
              ></icon>
            </button>
          )),
      )}
    </box>
  );
}

function FocusedClient() {
  const hypr = Hyprland.get_default();
  const focused = bind(hypr, "focusedClient");

  return (
    <box className="Focused" visible={focused.as(Boolean)} css="margin: 0 5px;">
      {focused.as(
        (client) =>
          client && (
            <label
              label={bind(client, "title").as((title) =>
                title.substring(0, 60),
              )}
            />
          ),
      )}
    </box>
  );
}

function Time({ format = "%H:%M:%S - %b %e" }) {
  const time = Variable<string>("").poll(
    1000,
    () => GLib.DateTime.new_now_local().format(format)!,
  );

  return (
    <label className="Time" onDestroy={() => time.drop()} label={time()} />
  );
}

export default function Bar(monitor: Gdk.Monitor) {
  const anchor =
    Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT;

  return (
    <window
      className="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
    >
      <centerbox css="min-height: 25px;">
        <box hexpand halign={Gtk.Align.START} css="margin-left: 7px;">
          <Workspaces />
          <FocusedClient />
        </box>
        <box>
          <Time />
        </box>
        <box hexpand halign={Gtk.Align.END} css="margin-right: 4px;">
          <SysTray />
          <SysStat />
          <Peripherals />
        </box>
      </centerbox>
    </window>
  );
}
