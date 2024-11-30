import { register, property } from "astal/gobject";
import { ConstructProps, Gtk, astalify } from "astal/gtk3";
import GdkPixbuf from "gi://GdkPixbuf";

interface AnimatedIconConstructorProps extends Gtk.Image.ConstructorProps {
    gif: string;
}

@register({ GTypeName: "AnimatedIcon" })
export class AnimatedIcon extends astalify(Gtk.Image) {
    private declare _animation: GdkPixbuf.PixbufAnimation;
    private declare _loop: boolean;
    private declare _gif: string;

    @property(Object)
    private set animation(animation: GdkPixbuf.PixbufAnimation) {
        this._animation = animation;
        this.loop = true;
    }
    public get animation(): GdkPixbuf.PixbufAnimation {
        return this._animation;
    }

    @property(String)
    private set gif(gif: string) {
        this._gif = gif;
    }
    public get gif(): string {
        return this._gif;
    }

    @property(Boolean)
    public set loop(loop: boolean) {
        this._loop = loop;
        this.animate();
    }
    public get loop(): boolean {
        return this._loop;
    }

    private animate(): void {
        if (this.loop) {
            this.set_from_animation(this.animation);
        } else {
            this.set_from_pixbuf(this.animation.get_static_image());
        }
    }

    toggle(): void {
        this.loop = !this.loop;
    }

    constructor(
        props: ConstructProps<AnimatedIcon, AnimatedIconConstructorProps, {}>,
    ) {
        super(props as any);
        this.animation = GdkPixbuf.PixbufAnimation.new_from_file(
            props.gif as string,
        );
    }
}
