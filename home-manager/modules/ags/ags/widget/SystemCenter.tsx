import { App } from "astal/gtk3";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import { Variable, bind } from "astal";
import { execAsync } from "astal/process";

import {
    glancesToJSON,
    bytesToHumanReadable,
    GlancesNetworkStat,
    GlancesCpuStat,
    GlancesMemoryStat,
} from "../lib/glances";
const glancesNetworkStat = glancesToJSON(
    "network",
) as Variable<GlancesNetworkStat>;
const glancesCpuStat = glancesToJSON("cpu") as Variable<GlancesCpuStat>;
const glancesMemoryStat = glancesToJSON("mem") as Variable<GlancesMemoryStat>;

export default function SystemCenter() {
    const anchor = Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT;

    return (
        <window
            name="systemcenter"
            namespace="ags-systemcenter"
            className="SystemCenter"
            exclusivity={Astal.Exclusivity.NORMAL}
            anchor={anchor}
            layer={Astal.Layer.OVERLAY}
            application={App}
            // keymode={Astal.Keymode.EXCLUSIVE}
        >
            <eventbox
                onClick={(self) => {
                    App.get_window("systemcenter")!.hide();
                }}
            >
                <box
                    className="SystemCenter"
                    widthRequest={400}
                    heightRequest={300}
                    css="background-color: #2b1931; margin: 10px 10px 0 0; border-radius: 20px;"
                    orientation={Gtk.Orientation.VERTICAL}
                >
                    <box
                        css="background-color: #4e2b4f; margin: 10px; border-radius: 15px 15px 10px 10px"
                        heightRequest={120}
                        className={"MonitorCenter"}
                        hexpand={true}
                    >
                        <button
                            css="background-color: #4e2b4f"
                            onClick={() => {
                                execAsync(["shutdown", "now"])
                                    .then((out) => console.log(out))
                                    .catch((err) => console.error(err));
                            }}
                        >
                            <icon
                                hexpand={true}
                                css="font-size: 48px;"
                                icon="shutdown-symbolic"
                            />
                        </button>
                        <button
                            css="background-color: #4e2b4f"
                            onClick={() => {
                                execAsync(["shutdown", "--reboot", "now"])
                                    .then((out) => console.log(out))
                                    .catch((err) => console.error(err));
                            }}
                        >
                            <icon
                                hexpand={true}
                                css="font-size: 48px;"
                                icon="restart-symbolic"
                            />
                        </button>
                        <button
                            css="background-color: #4e2b4f"
                            onClick={() => {
                                execAsync(["hyprctl", "dispatch", "exit"])
                                    .then((out) => console.log(out))
                                    .catch((err) => console.error(err));
                            }}
                        >
                            <icon
                                hexpand={true}
                                css="font-size: 48px;"
                                icon="logout-symbolic"
                            />
                        </button>
                    </box>
                    <box
                        css="margin: 0px 10px; background-color: #4e2b4f; border-radius: 10px 10px 15px 15px"
                        heightRequest={160}
                        className={"ControlCenter"}
                    >
                        <box
                            orientation={Gtk.Orientation.VERTICAL}
                            halign={Gtk.Align.START}
                            vexpand={false}
                        >
                            <box vexpand={true} css="margin: 0 0 0 20px;">
                                <icon
                                    css="font-size: 20px; margin: 0 10px 0 0;"
                                    icon="cpu-symbolic"
                                />
                                <slider
                                    sensitive={false}
                                    widthRequest={280}
                                    min={0}
                                    max={100}
                                    value={bind(glancesCpuStat).as(
                                        ({ cpu }) => cpu?.total,
                                    )}
                                />
                            </box>
                            <box vexpand={true} css="margin: 0 0 0 20px;">
                                <icon
                                    css="font-size: 20px; margin: 0 10px 0 0;"
                                    icon="randomaccessmemory-symbolic"
                                />
                                <slider
                                    sensitive={false}
                                    widthRequest={280}
                                    min={0}
                                    max={100}
                                    value={bind(glancesMemoryStat).as(
                                        ({ mem }) =>
                                            (100 * mem?.used) / mem?.total,
                                    )}
                                />
                            </box>
                            <box
                                vexpand={true}
                                orientation={Gtk.Orientation.HORIZONTAL}
                                css="margin: 0 0 0 20px;"
                            >
                                <icon
                                    css="font-size: 20px;"
                                    icon="networkspeed-symbolic"
                                />
                                <label
                                    widthChars={20}
                                    halign={Gtk.Align.START}
                                    xalign={0}
                                    label={bind(glancesNetworkStat).as(
                                        ({ network }) => {
                                            const wifi = network?.find(
                                                ({ interface_name }) =>
                                                    interface_name === "wlp3s0",
                                            );
                                            return (
                                                "Sent: " +
                                                bytesToHumanReadable(
                                                    wifi?.bytes_sent_rate_per_sec ??
                                                        0,
                                                ) +
                                                "/s"
                                            );
                                        },
                                    )}
                                />
                                <label
                                    label={bind(glancesNetworkStat).as(
                                        ({ network }) => {
                                            const wifi = network?.find(
                                                ({ interface_name }) =>
                                                    interface_name === "wlp3s0",
                                            );
                                            return (
                                                "Received: " +
                                                bytesToHumanReadable(
                                                    wifi?.bytes_recv_rate_per_sec ??
                                                        0,
                                                ) +
                                                "/s"
                                            );
                                        },
                                    )}
                                />
                            </box>
                        </box>
                    </box>
                </box>
            </eventbox>
        </window>
    );
}
