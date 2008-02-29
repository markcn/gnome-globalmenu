#include <config.h>

#include <gtk/gtk.h>

#include "libgnomenu/serverhelper.h"

#include "application.h"

#include "log.h"

static void window_destroy(GtkWidget * widget, gpointer useless){
	gtk_main_quit();
}
int main (int argc, char * argv []){
	GtkWindow * window;

	gtk_init(&argc, &argv);
	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_window_set_default_size(window, 400,20);
	application_new(window);
	g_signal_connect(window, "destroy", 
			window_destroy, NULL);
	gtk_widget_show_all(window);
	gtk_main();

	return 0;
}
/*
vim:ts=4:sw=4
*/