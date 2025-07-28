import App from "ags/gtk4/app";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import { For, With, Accessor, createBinding, createComputed } from "ags";
import { execAsync } from "ags/process";
import Hyprland from "gi://AstalHyprland";
import Battery from "gi://AstalBattery";
import BT from "gi://AstalBluetooth";
import WirePlumber from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";
import { createPoll } from "ags/time";
import { monitorFile } from "ags/file";
import GLib from "gi://GLib";
import {
  glancesToJSON,
  GlancesPerCpuStat,
  GlancesMemoryStat,
  bytesToHumanReadable,
} from "../lib/glances";
import { createGestureClick } from "../lib/gesture";
import { AnimatedIcon } from "./AnimatedIcon";

const glancesCpuStat = glancesToJSON("percpu") as Accessor<GlancesPerCpuStat>;
const glancesMemoryStat = glancesToJSON("mem") as Accessor<GlancesMemoryStat>;

// Sourced from:
// https://www.reddit.com/media?url=https%3A%2F%2Fi.redd.it%2Fqf46od2du2q11.gif
// https://www.reddit.com/r/PixelArt/comments/9l7r4i/oc_bongo_cat_sped_up/
// Should write nix module that fetches this automatically
function BongoCat() {
  const bongoCat = new AnimatedIcon({
    gif: `${SRC}/gifs/bongocat-32.gif`,
  });

  let prevInput = setTimeout(() => (bongoCat.loop = false), 500);

  monitorFile("/tmp/keypressevent", () => {
    clearTimeout(prevInput);
    bongoCat.loop = true;
    prevInput = setTimeout(() => (bongoCat.loop = false), 500);
  });

  return bongoCat;
}

function SysTray() {
  const tray = Tray.get_default();
  const items = createBinding(tray, "items");

  const init = (btn: Gtk.MenuButton, item: Tray.TrayItem) => {
    btn.menuModel = item.menuModel;
    btn.insert_action_group("dbusmenu", item.actionGroup);
    item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup);
    });
  };

  return (
    <box css=" background: #4E2B4F; border-radius: 10px 3px 3px 10px; padding: 0 5px; margin: 3px 2px; ">
      <For each={items}>
        {(item) => (
          <menubutton $={(self) => init(self, item)}>
            <image gicon={createBinding(item, "gicon")} />
          </menubutton>
        )}
      </For>
    </box>
  );
}

function Wifi() {
  const { wifi } = Network.get_default();

  return (
    <image
      tooltipText={createBinding(wifi, "ssid")}
      class="Wifi"
      iconName={createBinding(wifi, "iconName")}
    />
  );
}

function Bluetooth() {
  const bluetooth = BT.get_default();

  const iconName = createComputed(
    [
      createBinding(bluetooth, "isPowered"),
      createBinding(bluetooth, "isConnected"),
    ],
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

  const devices = createComputed(
    [createBinding(bluetooth, "devices")],
    (devices) => {
      return devices
        .filter((device) => device.connected)
        .map((device) => device.alias)
        .join("\n");
    },
  );

  return <box>{<image iconName={iconName} tooltipText={devices} />}</box>;
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
  const gesture = createGestureClick({
    pressed: () => {
      execAsync(["ags", "toggle", "systemcenter"]);
    },
  });

  return (
    <box $={(self) => self.add_controller(gesture)}>
      <box
        hexpand
        halign={Gtk.Align.END}
        css=" background: #4E2B4F; border-radius: 3px; padding: 0 5px; margin: 3px 2px; "
      >
        <BatteryLevel />
        <CPU />
        <Memory />
      </box>
    </box>
  );
}

function Audio() {
  const speaker = WirePlumber.get_default()?.audio.defaultSpeaker!;
  const microphone = WirePlumber.get_default()?.audio.defaultMicrophone!;

  const volumeGestureClickController = createGestureClick({
    pressed: () => {
      speaker.set_mute(!speaker.get_mute());
    },
  });

  const microphoneGestureClickController = createGestureClick({
    pressed: () => {
      microphone.set_mute(!microphone.get_mute());
    },
  });

  return (
    <box>
      <box $={(self) => self.add_controller(volumeGestureClickController)}>
        <image
          iconName={createBinding(speaker, "volumeIcon")}
          tooltipText={createBinding(
            speaker,
            "volume",
          )((v) => `${Math.round(v * 100)}%`)}
        />
      </box>
      <box $={(self) => self.add_controller(microphoneGestureClickController)}>
        <image
          iconName={createBinding(microphone, "volumeIcon")}
          tooltipText={createBinding(
            microphone,
            "volume",
          )((v) => `${Math.round(v * 100)}%`)}
        />
      </box>
    </box>
  );
}

function CPU() {
  return (
    <box css="margin: 0 2px;">
      <image
        iconName="cpu-symbolic"
        tooltipText={glancesCpuStat(({ percpu }) =>
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
      <image
        iconName="randomaccessmemory-symbolic"
        tooltipText={glancesMemoryStat(({ mem }) =>
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
    <box class="Battery" visible={createBinding(bat, "isPresent")}>
      <image
        iconName={createBinding(bat, "batteryIconName")}
        tooltipText={createBinding(bat, "percentage")((p) => `${p * 100}%`)}
      />
    </box>
  );
}

function Workspaces() {
  const hypr = Hyprland.get_default();
  const workspaces = createComputed(
    [createBinding(hypr, "workspaces")],
    (workspaces) =>
      workspaces.sort((a: { id: number }, b: { id: number }) => a.id - b.id),
  );

  return (
    <box class="Workspaces">
      <For each={workspaces}>
        {(ws) => (
          <button
            class={createBinding(
              hypr,
              "focusedWorkspace",
            )((fw) => (ws === fw ? "focused" : ""))}
            onClicked={() => ws.focus()}
            css="margin: 3px;"
          >
            <image
              iconName={createBinding(
                hypr,
                "focusedWorkspace",
              )((fw) =>
                ws === fw ? "circle-symbolic" : "circle-outline-symbolic",
              )}
            />
          </button>
        )}
      </For>
    </box>
  );
}

function FocusedClient() {
  const hypr = Hyprland.get_default();
  const focused = createBinding(hypr, "focusedClient");

  return (
    <box class="Focused" visible={focused(Boolean)} css="margin: 0 5px;">
      <With value={focused}>
        {(client) =>
          client && <label label={client.get_title()?.substring(0, 60)} />
        }
      </With>
    </box>
  );
}

function Clock({ format = "%H:%M:%S - %b %d" }) {
  const time = createPoll("", 1000, () => {
    return GLib.DateTime.new_now_local().format(format)!;
  });

  return (
    <menubutton>
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
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
      class="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
      layer={Astal.Layer.BOTTOM}
      visible
    >
      <centerbox css="min-height: 25px;">
        <box
          $type="start"
          hexpand
          halign={Gtk.Align.START}
          css="margin-left: 7px;"
        >
          <Workspaces />
          <FocusedClient />
        </box>
        <box $type="center">
          <Clock />
        </box>
        <box
          $type="end"
          hexpand
          halign={Gtk.Align.END}
          css="margin-right: 4px;"
        >
          <BongoCat />
          <SysTray />
          <SysStat />
          <Peripherals />
        </box>
      </centerbox>
    </window>
  );
}
