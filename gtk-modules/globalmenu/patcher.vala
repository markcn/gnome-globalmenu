public class Patcher {
	MenuBar menubar;
	public Patcher() {
		menubar = new MenuBar();
	}
	~Patcher() {
		Superrider.release_all();
	}
	internal class MenuBar {
		[CCode (cname="G_STRUCT_OFFSET(GtkWidgetClass, map)")]
		private extern const int OffsetMap;
		[CCode (cname="G_STRUCT_OFFSET(GtkWidgetClass, size_request)")]
		private extern const int OffsetSizeRequest;
		[CCode (cname="G_STRUCT_OFFSET(GtkWidgetClass, can_activate_accel)")]
		private extern const int OffsetCanActivateAccel;
		private static delegate void MapFunc(Gtk.Widget? widget);
		private static delegate void SizeRequestFunc(Gtk.Widget? widget, ref Gtk.Requisition req);
		private static delegate bool CanActivateAccelfunc(Gtk.Widget? widget);

		public MenuBar() {
			Superrider.superride(typeof(Gtk.MenuBar), OffsetMap, (void*)map);
			Superrider.superride(typeof(Gtk.MenuBar), OffsetSizeRequest, (void*)size_request);
			Superrider.superride(typeof(Gtk.MenuBar), OffsetCanActivateAccel, (void*)can_activate_accel);
		}
		public static void map(Gtk.Widget? widget) {
			MapFunc super = (MapFunc) Superrider.peek_super(typeof(Gtk.MenuBar), OffsetMap);
			MapFunc @base = (MapFunc) Superrider.peek_base(typeof(Gtk.MenuBar), OffsetMap);

			message("map called");

			var factory = MenuBarInfoFactory.get();
			var info = factory.create(widget as Gtk.MenuBar);
			if((info.quirks & MenuBarInfo.QuirkType.REGULAR_WIDGET) != 0) 
				super(widget);
			else {
				widget.set_flags(Gtk.WidgetFlags.MAPPED);
				@base(widget);
				if(widget.window != null) widget.window.hide();
			}
		}
		public static void size_request(Gtk.Widget? widget, ref Gtk.Requisition req) {
			message("size_request called");
			assert(widget is Gtk.MenuBar);
			var factory = MenuBarInfoFactory.get();
			var info = factory.create(widget as Gtk.MenuBar);

			SizeRequestFunc super = (SizeRequestFunc) 
				Superrider.peek_super(typeof(Gtk.MenuBar), OffsetSizeRequest);

			super(widget, ref req);

			if((info.quirks & MenuBarInfo.QuirkType.REGULAR_WIDGET) != 0) 
				return;

			req.width = 0;
			req.height = 0;
		}
		public static bool can_activate_accel(Gtk.Widget? widget) {
			assert(widget is Gtk.MenuBar);
			return widget.sensitive;
		}
	}
}
