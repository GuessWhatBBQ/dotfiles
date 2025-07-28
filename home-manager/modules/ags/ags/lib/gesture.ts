import { Gtk } from "ags/gtk4";

export type GestureClickSignalName =
    | "pressed"
    | "released"
    | "stopped"
    | "unpaired-release";

export type GestureClickSignalHandlers = {
    [K in GestureClickSignalName]?: K extends "pressed" | "released"
        ? (
              gesture: Gtk.GestureClick,
              nPress: number,
              x: number,
              y: number,
          ) => void
        : K extends "stopped"
          ? (gesture: Gtk.GestureClick) => void
          : (gesture: Gtk.GestureClick, x: number, y: number) => void;
};

/**
 * Creates a new Gtk.GestureClick and attaches all signal handlers
 */
export function createGestureClick(
    handlers: GestureClickSignalHandlers,
): Gtk.GestureClick {
    const gesture = Gtk.GestureClick.new();

    if (handlers.pressed) {
        gesture.connect("pressed", handlers.pressed);
    }

    if (handlers.released) {
        gesture.connect("released", handlers.released);
    }

    if (handlers.stopped) {
        gesture.connect("stopped", handlers.stopped);
    }

    if (handlers["unpaired-release"]) {
        gesture.connect("unpaired-release", handlers["unpaired-release"]);
    }

    return gesture;
}
