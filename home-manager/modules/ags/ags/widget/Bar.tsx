import { App } from "astal/gtk3";
import { Variable, GLib, bind, execAsync } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import Battery from "gi://AstalBattery";
import BT from "gi://AstalBluetooth";
import Wp from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";
import {
  glancesToJSON,
  GlancesPerCpuStat,
  GlancesMemoryStat,
  bytesToHumanReadable,
} from "../lib/glances";
import { AnimatedIcon } from "./AnimatedIcon";

const glancesCpuStat = glancesToJSON("percpu") as Variable<GlancesPerCpuStat>;
const glancesMemoryStat = glancesToJSON("mem") as Variable<GlancesMemoryStat>;

// Sourced from:
// https://www.reddit.com/media?url=https%3A%2F%2Fi.redd.it%2Fqf46od2du2q11.gif
// https://www.reddit.com/r/PixelArt/comments/9l7r4i/oc_bongo_cat_sped_up/
// Should write nix module that fetches this automatically
function BongoCat() {
  const bongoCat = new AnimatedIcon({
    gif: "/home/guesswhatbbq/Code/dotfiles/home-manager/modules/ags/ags/icons/bongocat-small.gif",
  });

  const a = Variable({}).watch(
    `sudo libinput debug-events --device /dev/input/event17`,
    () => {
      bongoCat.loop = true;
      setTimeout(() => (bongoCat.loop = false), 1000);
    },
  );

  return (
    <eventbox
      onClick={() => {
        bongoCat.toggle();
      }}
    >
      {bongoCat}
    </eventbox>
  );
}

function SysTray() {
  const tray = Tray.get_default();
  return (
    <box css=" background: #4E2B4F; border-radius: 10px 3px 3px 10px; padding: 0 5px; margin: 3px 2px; ">
      {bind(tray, "items").as((items) =>
        items.map((item) => (
          <menubutton
            tooltipMarkup={bind(item, "tooltipMarkup")}
            usePopover={false}
            actionGroup={bind(item, "action-group").as((ag) => [
              "dbusmenu",
              ag,
            ])}
            menuModel={bind(item, "menu-model")}
          >
            <icon gicon={bind(item, "gicon")} />
          </menubutton>
        )),
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
        return "bluetooth-paired";
      } else if (bluetooth.isPowered) {
        return "bluetooth-active";
      } else {
        return "bluetooth-disabled";
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
          icon={bind(iconName).as((i) => `${i}`)}
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
    <eventbox onClick={() => execAsync(["ags", "toggle", "systemcenter"])}>
      <box
        hexpand
        halign={Gtk.Align.END}
        css=" background: #4E2B4F; border-radius: 3px; padding: 0 5px; margin: 3px 2px; "
      >
        <BatteryLevel />
        <CPU />
        <Memory />
      </box>
    </eventbox>
  );
}

function Audio() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!;
  const microphone = Wp.get_default()?.audio.defaultMicrophone!;

  return (
    <box>
      <eventbox
        onClick={() => {
          speaker.set_mute(!speaker.get_mute());
          console.log(speaker.volumeIcon);
        }}
      >
        <icon
          icon={bind(speaker, "volumeIcon")}
          tooltipText={bind(speaker, "volume").as(
            (v) => `${Math.round(v * 100)}%`,
          )}
        />
      </eventbox>
      <eventbox
        onClick={() => {
          microphone.set_mute(!microphone.get_mute());
          console.log(microphone.volumeIcon);
        }}
      >
        <icon
          icon={bind(microphone, "volumeIcon")}
          tooltipText={bind(microphone, "volume").as(
            (v) => `${Math.round(v * 100)}%`,
          )}
        />
      </eventbox>
    </box>
  );
}

function CPU() {
  return (
    <box css="margin: 0 2px;">
      <icon
        icon="cpu-symbolic"
        tooltipText={bind(glancesCpuStat).as(({ percpu }) =>
          percpu
            ? percpu
                ?.map((cpu) => `CPU ${cpu.cpu_number}: ${cpu.total}`)
                .join("\n")
            : ``,
        )}
      />
    </box>
  );
}

function Memory() {
  return (
    <box css="margin: 0 1px;">
      <icon
        icon="randomaccessmemory-symbolic"
        tooltipText={bind(glancesMemoryStat).as(({ mem }) =>
          mem
            ? Object.entries(
                Object.keys(mem)
                  .filter((key) => key !== "percent")
                  .reduce((acc, key) => {
                    acc[key] = bytesToHumanReadable(mem[key]);
                    return acc;
                  }, mem),
              )
                .map(([key, value]) => `${key}: ${value}`)
                .join("\n")
            : ``,
        )}
      />
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
          .sort((a: { id: number }, b: { id: number }) => a.id - b.id)
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
      name="bar"
      namespace="ags-bar"
      application={App}
      className="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
      layer={Astal.Layer.BOTTOM}
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
          <BongoCat />
          <SysTray />
          <SysStat />
          <Peripherals />
        </box>
      </centerbox>
    </window>
  );
}
