import { register, property } from "ags/gobject";
import { Gtk } from "ags/gtk4";
import GdkPixbuf from "gi://GdkPixbuf";
import GLib from "gi://GLib";
import Gio from "gi://Gio";

interface AnimatedIconConstructorProps extends Gtk.Image.ConstructorProps {
  gif: string;
}

@register({ GTypeName: "AnimatedIcon" })
export class AnimatedIcon extends Gtk.Image {
  declare private _animation: GdkPixbuf.PixbufAnimation;
  declare private _loop: boolean;
  @property(String) gif = "";
  declare private _iter: GdkPixbuf.PixbufAnimationIter;

  private set animation(animation: GdkPixbuf.PixbufAnimation) {
    this._animation = animation;
    this._iter = animation.get_iter(null);
    this.loop = true;
  }
  public get animation(): GdkPixbuf.PixbufAnimation {
    return this._animation;
  }

  public set loop(loop: boolean) {
    this._loop = loop;
    this.animate();
  }
  public get loop(): boolean {
    return this._loop;
  }

  private animate(): void {
    if (this.loop) {
      this.set_from_pixbuf(this._iter.get_pixbuf());

      // Advance to next frame based on the delay time
      GLib.timeout_add(
        GLib.PRIORITY_DEFAULT,
        this._iter.get_delay_time(),
        () => {
          this._iter.advance(null);
          this.animate();
          return GLib.SOURCE_REMOVE; // ensure single-shot
        },
      );
    } else {
      this.set_from_pixbuf(this.animation.get_static_image());
    }
  }

  toggle(): void {
    this.loop = !this.loop;
  }

  constructor(props: Partial<AnimatedIconConstructorProps>) {
    super(props as any);
    this.animation = GdkPixbuf.PixbufAnimation.new_from_file(
      props.gif as string,
    );
  }
}

@register({ GTypeName: "GIF" })
export class GIF extends Gtk.Video {
  declare private _loop: boolean;
  @property(String) gif = "";
  declare private _file: Gio.File;

  public set loop(loop: boolean) {
    this._loop = loop;
    this.set_loop(loop);
    this.animate();
  }
  public get loop(): boolean {
    return this._loop;
  }

  private animate(): void {
    this.set_file(this.file);
  }

  toggle(): void {
    this.loop = !this.loop;
  }

  constructor(props: Partial<AnimatedIconConstructorProps>) {
    super(props as any);
    this.set_autoplay(true); // Optional: start playing automatically
    this.set_loop(true); // Loop playback
    this.file = Gio.File.new_for_path(props.gif as string);
  }
}
